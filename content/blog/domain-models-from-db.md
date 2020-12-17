---
type: blog
title: SQL JSON & Domain Objects
published: 2020-12-16
description: An unlikely pairing of Postgres, Jackson and Kotlin
---

SQL databases are amazing. They give you tools to create extremely powerful guarantees about the integrity of your data, evolve that data over time, and ask some pretty complex questions about it with very little effort.

```
SELECT
	sections.title,
	questions.label,
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

```
data class Section(
    val title: String,
    val questions: List<Question>
) {
    fun bestAnswers() = questions.filter { it.hasGreatAnswer() }
}

data class Question(
    val label: String,
    val category: Category,
    val answer: Answer?
) {
    fun hasGreatAnswer() = category == BREAD && answer?.hasMuchLove()
}
```

Combining the two approaches however is often more awkward than you'd expect