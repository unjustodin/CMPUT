/* query one COMPLETE*/
SELECT uid
FROM ubadges
WHERE bname = 'gold'

INTERSECT

SELECT poster
FROM posts
WHERE pid IN (SELECT pid FROM questions);

/*query two */
SELECT pid, title
FROM posts
WHERE title LIKE '%relational database%'
OR (pid IN (SELECT pid
FROM tags
WHERE tag LIKE "%relational%")
AND pid IN (SELECT pid
FROM tags
WHERE tag LIKE "%atabase%"));

/*query three COMPLETE*/
SELECT p1.pid, p1.pdate
FROM posts p1, posts p2, questions, answers
WHERE p1.pid = questions.pid
AND p2.pid = answers.pid
AND answers.qid = p1.pid
AND 3 >= (julianday(p2.pdate) - julianday(p1.pdate));


/*query four need to figure out how to check for two answers*/
SELECT p1.poster
FROM posts p1, posts p2, questions q, answers a
WHERE p1.pid = q.pid
AND p2.pid = a.pid
AND p2.poster = p1.poster;

/*query five COMEPLTE */
SELECT poster
FROM posts, questions
WHERE posts.pid = questions.pid

INTERSECT

SELECT poster
FROM posts, answers
WHERE posts.pid = answers.pid

INTERSECT

SELECT poster
FROM posts, votes
WHERE posts.pid = votes.pid
AND 3 < 
(SELECT count(poster)
FROM posts, votes
WHERE posts.pid = votes.pid);

/*query six */

/*query seven */

SELECT tag, pdate
FROM tags, posts
WHERE (SELECT DISTINCT pdate
FROM posts) = pdate 
AND tags.pid = posts.pid

/*query eight */

/*query nine */

/*query ten */
