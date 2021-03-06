/* query one COMPLETE */
SELECT uid
FROM ubadges
WHERE bname = 'gold'

INTERSECT

SELECT poster
FROM posts,questions
WHERE posts.pid = questions.pid;

/*query two COMPLETE*/
SELECT distinct posts.pid, title
FROM posts,tags t1, tags t2
WHERE title LIKE '%relational database%'
OR t1.pid = t2.pid
AND posts.pid = t1.pid
AND t1.tag like '%relational%'
AND t2.tag like '%database%';

/*query three COMPLETE*/
SELECT p1.pid, p1.pdate
FROM posts p1, posts p2, questions, answers
WHERE p1.pid = questions.pid
AND p2.pid = answers.pid
AND answers.qid = p1.pid
AND 3 >= (julianday(p2.pdate) - julianday(p1.pdate));


/*query four COMPLETE */
SELECT poster as user_id
FROM posts, questions
WHERE posts.pid = questions.pid
AND 2 < (SELECT count(*)
FROM answers
WHERE posts.pid = answers.qid);

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

/*query six COMPLETE*/

SELECT DISTINCT tags.tag, vote_amount, post_amount
    FROM tags
    LEFT JOIN(select DISTINCT tag, COUNT(*) as vote_amount from votes, tags
            WHERE tags.pid = votes.pid
            group by tag) as v
    ON v.tag = tags.tag
    LEFT JOIN 
        (SELECT tag, COUNT(*) as post_amount FROM posts, tags
        WHERE posts.pid = tags.pid
        group by tag) as p
        ON p.tag = tags.tag
    ORDER by vote_amount DESC
    LIMIT 3;
/*query seven*/

SELECT DISTINCT pdate ,ptag as'most popular tag',aposts as'amount of posts'
FROM posts
INNER JOIN (SELECT pdate, tag as ptag, COUNT(*) as aposts
            FROM posts, tags
            WHERE posts.pid = tags.pid
            group by tags.tag
            ORDER BY count(*) DESC
            LIMIT 1) USING(pdate);

/*query eight COMPLETE*/

SELECT DISTINCT posts.poster as user_id, question_amount, answer_amount, vote_out_amount, vote_in_amount
    FROM posts

    LEFT JOIN (SELECT poster, count(pid) as answer_amount
                FROM posts
                WHERE pid in (SELECT pid FROM answers)
                GROUP BY poster) as a
    on posts.poster = a.poster

    LEFT JOIN (SELECT poster, count(pid) as question_amount
                FROM posts
                WHERE pid in (SELECT pid FROM questions)
                GROUP BY poster) as q
    on posts.poster = q.poster

    LEFT JOIN (SELECT uid, count(uid) as vote_out_amount
                FROM votes
                WHERE uid in (SELECT uid FROM users)
                GROUP BY uid) as v_out
    on posts.poster = v_out.uid

    LEFT JOIN (SELECT poster, count(*) as vote_in_amount
                FROM posts, votes
                where posts.pid = votes.pid
                group by posts.poster) as v_in
    on posts.poster = v_in.poster;
/*query nine */
DROP VIEW IF EXISTS questioninfo;

CREATE VIEW questioninfo(pid,uid,theaid,voteCnt,ansCnt) AS
    SELECT DISTINCT questions.pid,poster,qinfo.theaid, voteCnt, ansCnt
        FROM questions
        LEFT JOIN
            (SELECT questions.pid,poster,theaid
            FROM posts, questions, answers, votes
            WHERE posts.pid = questions.pid
            GROUP BY questions.pid) AS qinfo
            ON qinfo.pid = questions.pid
        LEFT JOIN
            (SELECT questions.pid,count(*) AS ansCnt
            FROM answers, questions
            WHERE answers.qid = questions.pid
            GROUP BY questions.pid) AS ans
            ON ans.pid = questions.pid
        LEFT JOIN
            (SELECT questions.pid,count(*) AS voteCnt
            FROM votes, questions
            WHERE votes.pid = questions.pid
            GROUP BY questions.pid) AS vote
            ON vote.pid = questions.pid

/*query ten */
