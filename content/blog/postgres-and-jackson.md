---
type: blog
title: SQL JSON & Domain Objects
published: 2021-02-14
description: An unlikely pairing of Postgres, Jackson and Kotlin
---

SQL databases are amazing. They give you tools to create extremely powerful guarantees about the integrity of your data, evolve that data over time, and ask some pretty complex questions about it with relatively little effort.

As an example let's say we have an application that handles questionnaires:

- Each `Questionnaire` has many `Sections`
- Each `Section` has many `Questions`
- Each `Question` can have one `Answer`

We could find all the sections with answers where the person loves bread like this!:

```sql
SELECT
    sections.title AS section_title,
    questions.label AS question_label,
    questions.category,
    questions.answer
FROM questions
INNER JOIN sections ON questions.section_id = sections.id
WHERE
    questions.category = 'BREAD' AND
    questions.answer ILIKE '%I LOVE%';
```

At the same time, using well-structured objects or domain types is also a powerful way of modelling pieces of an application.

```kotlin
class Section(
    val title: String,
    val questions: List<Question>
) {
    fun bestAnswers() = questions.filter { it.hasGreatAnswer() }
}

class Question(
    val label: String,
    val category: Category,
    val answer: Answer?
) {
    fun hasGreatAnswer() = category == BREAD && answer?.hasMuchLove()
}
```

Combining the two approaches however is often more awkward than you'd expect. The awkwardness here is that SQL queries produce `flat results`:

![table](https://user-images.githubusercontent.com/14013616/107861636-0fae2c80-6e3f-11eb-9aa7-7f3bc510600a.png)

But our domain model contains multiple `nested structures` (e.g. questionnaires contain sections, which contain questions).

This mismatch in shape is sometimes called [object relational impedance mismatch](https://en.wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch).

## How has this been solved?

Generally there are two categories of common solutions to this:

- Use raw SQL queries and stitch the relevant data together manually (e.g. query the questions and sections table separately and then for each matching ID build up a list of questions for each section)
- Use an ORM (Object Relational Mapper)

An ORM effectively abstracts the first option away.

## Problems with these approaches

Both approaches have their pros and cons.

`Manually stitching` gives you the power and flexibility of raw SQL but the stitching code can be error prone and painful to maintain.

Using an `ORM` gives you stronger guarantees data will be constructed correctly, but you lose a lot of the flexibility of raw SQL (or worse, the complications of mixing the two!) and unless you understand how to use the ORM properly you can easily run into serious performance problems.

In Java / Kotlin `JPA with Hibernate` is the de-facto framework for dealing with relational databases. It's an impressive and mature framework / standard, but it's also extremely complex and a very high level abstraction (what's going on under the hood can often be extremely opaque).

In my particular case I ran into a few grievances with it:

- The mapping code could be quite awkward and boilerplate heavy - often having to fish out related objects to make a change.
- Queries with deeply nested objects became very slow, and were very difficult to debug.
- Magical annotations `@Lazy` `@Eager` for fetching strategies and remembering where to put `@JoinColumn` and `@OneToMany` / `@OneToOne` left me scratching my head more often than I'd like to admit.

None of these points were show stoppers, and I'm sure with more time and experience they'd become less painful, but I couldn't help but think - is there a less abstract way to do this?

## JSON and Jackson

Of the "magical" things you can do in Java / Kotlin, I was surprised by how awesome and painless using Jackson ([A serialisation/deserialisation library for Java](https://github.com/FasterXML/jackson)) was. Given a JSON object like:

```json
{
  "title": "Section 1",
  "questions": [
    {
      "label": "Do you love bread?",
      "category": "BREAD",
      "answer": "Absolutely"
    },
    {
      "label": "Do you love baguettes?",
      "category": "BREAD",
      "answer": null
    }
  ]
}
```

And Kotlin classes:

```kotlin
class Section(
    val title: String,
    val questions: List<Question>
)

class Question(
    val label: String,
    val category: Category,
    val answer: Answer?
)
```

You can magically convert that JSON into a `Section`:

```kotlin
jacksonObjectMapper().readValue<Section>(jsonString)
```

What's effectively happening is the Jackson object mapper is taking the name of each object key and matching it with an argument to the constructor of the relevant class.

## Hasura Graphql Engine

At the time I'd been working on a side project that uses [Hasura](https://hasura.io/) - a graphql server that can auto generate an api based from a postgres schema. I stumbled across a blog post explaining the architecture behind its high performance - taking data from postgres and returning deeply nested JSON structures for graphql responses (it's a [fantastic blog post](https://hasura.io/blog/architecture-of-a-high-performance-graphql-to-sql-server-58d9944b8a87/) and well worth a read).

At first, they queried the flat results and used a transformation function in Haskell to turn that data into JSON. However, they found that actually using Postgres' JSON aggregation functions produced a 3-6x improvement in speed!

This got me thinking.

We were using Postgres on our project, and Jackson painlessly converts JSON to Kotlin objects. Can we combine the two somehow?

## JSON aggregate functions

It's definitely not perfect, but It was a lot less painful than I'd expected. Here's a query for getting sections:

```sql
SELECT
    json_agg(
        json_build_object(
          'title', sections.title,
          'questions', questions.json
        )
    )
FROM sections
INNER JOIN (
    SELECT
        questions.section_id,
        json_agg(
            json_build_object(
                'label', questions.label,
                'category', questions.category,
                'answer', questions.answer
            )
        ) json
    FROM questions
    GROUP BY questions.section_id
) questions ON questions.section_id = sections.id;
```

Whilst it might not be to everyone's taste once the nesting gets deeper you could split the strings up into smaller queries:

```kotlin
@Language("SQL")
const val getQuestions = """
SELECT
    questions.section_id,
    json_agg(
        json_build_object(
            'label', questions.label,
            'category', questions.category,
            'answer', questions.answer
        )
    ) json
FROM questions
GROUP BY questions.section_id
"""

@Language("SQL")
const val getSections = """
SELECT
    json_agg(
        json_build_object(
            'title', sections.title,
            'questions', questions.json
        )
    ) output
FROM sections
INNER JOIN ($questions) questions ON questions.section_id = sections.id
"""
```

This gives you back a single row from postgres:

| output                                             |
| -------------------------------------------------- |
| [ { "title": "Section 1", "questions": [ ... ] } ] |

Jackson can then take the output string and parse it into a `List<Section>`

### Sealed Classes

[Sealed classes](https://kotlinlang.org/docs/sealed-classes.html) in my opinion are one of the best features of Kotlin - they let you model a restricted subset of a class where all members are known at compile time (it's a similar concept to [algebraic data types seen in some typed functional languages](https://www.schoolofhaskell.com/school/starting-with-haskell/introduction-to-haskell/2-algebraic-data-types)).

Say an answer to a question got more complicated and needed the concept of being approved by a reviewer, you could do something like this:

```kotlin
sealed class Answer {
  object NotAnswered() : Answer()
  class Answered(val answer: String) : Answer()
  class Approved(val answer: String, val reviewer: Username) : Answer()
}
```

Now whenever we use an `Answer` in the application we have to handle all the possible cases explicitly:

```kotlin
when (answer) {
  is NotAnswered -> doSomething()
  is Answered -> doSomethingWithAnswer(answer.answer)
  is Approved -> doSomethingWithReviewer(answer.reviewer)
}
```

Jackson won't read sealed classes by default, but we can write a custom `Deserializer` to create an `Answer` from JSON:

```kotlin
class AnswerDeserializer : JsonDeserializer<Answer>() {

    override fun deserialize(p: JsonParser, ctxt: DeserializationContext): Answer =
        p.readValueAs(Intermediate::class.java).toAnswer()

    class Intermediate(
        val answer: String?,
        val reviewedBy: String?
    ) {
        fun toAnswer(): Answer = when {
            answer != null && reviewedBy != null -> Approved(answer, reviewedBy)
            answer != null && reviewedBy == null -> Answered(answer)
            else -> NotAnswered
        }
    }
}
```

And modify our query to have this intermediate structure:

```kotlin
@Language("SQL")
const val getQuestions = """
SELECT
    questions.section_id,
    json_agg(
        json_build_object(
            'label', questions.label,
            'category', questions.category,
            'answer', json_build_object(
                'answer', questions.answer,
                'reviewedBy', questions.reviewedBy
            )
        )
    ) json
FROM questions
GROUP BY questions.section_id
"""
```

Registering the deserializer on the jackson object mapper means it can recognise `Answers` now.

There are some potential downsides to this approach to watch out for however:

- You're tied to Postgres
- It's worth taking care to not get overzealous in splitting queries up!
- IntelliJ has some amazing autocompletion and schema detection but only in the paid for ultimate edition

This combination has been surprisingly effective on our current project though - it's made database code more transparent and sped up nested queries significantly (one query that was taking ~5s went down to ~100ms! - I'm sure we were abusing hibernate awfully!).

You can find a [full working example here](https://github.com/andrewMacmurray/postgres-jackson-example)
