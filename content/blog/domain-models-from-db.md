---
type: blog
title: SQL JSON & Domain Objects
published: 2020-12-16
draft: true
description: An unlikely pairing of Postgres, Jackson and Kotlin
---

SQL databases are amazing. They give you tools to create extremely powerful guarantees about the integrity of your data, evolve that data over time, and ask some pretty complex questions about it with very little effort.

```plsql
SELECT
	sections.title AS section_title,
	questions.label As question_label,
	answers.answer,
	answers.answered_on
	FROM questions
INNER JOIN answers  ON answers.question_id  = questions.id
INNER JOIN sections ON questions.section_id = sections.id
WHERE
	questions.category = 'BREAD' AND
	answers.answer ILIKE "%I LOVE%";
```



Using well structured objects or domain types can also be a pretty nice way of modelling pieces of an application.

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

Combining the two approaches however is often more awkward than you'd expect. The awkwardness here is that SQL queries produce flat results:

| section_title | question_label           | answer      | answered_on |
| ------------- | ------------------------ | ----------- | ----------- |
| Bread Rolls   | Do you love bread rolls? | Absolutely! | 2021-01-05  |
| Baguettes     | Do you love baguettes?   | YES!!       | 2021-01-06  |

But domain models often have nested structures (e.g. sections contain lists of questions).

This sometimes called "object relational impedance mismatch".



## How has this been solved?

Generally there are two categories of common solutions to this:

+ Use raw SQL queries and stitch the relevant data together manually (e.g. query the questions and sections table separately and then for each matching ID build up a list of questions for each section)
+ Use an ORM (Object relational mapper)

An ORM effectively abstracts  the first option away.

## Problems with these approaches

Both approaches have their pros and cons

Manually stitching gives you the power and flexibility of raw SQL but the stitching code can be error prone and painful to maintain.

ORMs provide more safety that data is constructed correctly, but you lose a lot of the flexibility of raw SQL (or worse, the complications of mixing the two!) and unless you understand how to use the ORM properly you can easily run into serious performance problems.

In Java / Kotliln JPA with Hibernate is the defacto ORM. It's an impressive and mature framework / standard, but it's also extremely complex and very high level abstraction (what's going on under the hood can often be extremely opaque).

In my particular case I ran into a few grievances with it:

+ The mapping code could be quite awkward and boilerplate heavy --- MORE DETAIL
+ Queries with deeply nested objects became very slow, and were very difficult to debug
+ Magical annotations `@Lazy` `@Eager` for fetching strategies and remembering where to put `@JoinColum` and `@OneToMany` / `@OneToOne` left me scratching my head more often than I'd like

None of these were show stoppers and I'm sure with more time and experience they'd become less painful, but I couldn't help but think - is there another way to do this?

## JSON and Jackson

Of the "magical" things you can do in Java / Kotlin, I was surprised by how awesome and painless Jackson's Object mapper was. Given a JSON object like:

```json
{
	"title": "Section 1",
	"questions": [
			{
				"label": "Question 1",
				"category": "BREAD",
				"answer": "Do you love bread?"
			},
			{
				"label": "Question 2",
				"category": "BREAD",
				"answer": null
			}
	]
}
```

and Kotlin classes:

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

You can magically convert that  JSON into a `Section`

```kotlin
jacksonObjectMapper().readValue<Section>(jsonString)
```

##  Hasura Graphql Engine

At the time I'd been working on a side project that uses Hasura - a graphql server that auto generates an api based from a postgres schema. I stubmbled across a blog post explaning how they managed to produce high performance queries using the data from postgres to make deeply nested JSON structures for graphql responses. (it's a fantastic blog post and well worth a read https://hasura.io/blog/architecture-of-a-high-performance-graphql-to-sql-server-58d9944b8a87/)

At first they queried the flat results and used a transformation function in Haskell to turn that data into JSON. However they found that actually using postgres' JSON aggregation functions produced a 3-6x improvement in speed!

This got me thinking.

We were using Posgtres on our project, and Jackson magically converts JSON to Kotlin objects. Can we combine the two somehow?

## JSON aggregate functions

It's definitely not perfect but It was a lot less painful than I'd expected

```plsql
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
	GROUP BY q.section_id
) questions ON questions.section_id = sections.id;
```

