SELECT
    *
FROM
    crime_scene_report
WHERE
    TYPE = 'murder'
    AND city = 'SQL City'
    AND date = '20180115';
--
--
SELECT
    *
FROM
    person
WHERE
    address_street_name = 'Franklin Ave'
    AND name LIKE 'Annabel %'
--
--
SELECT
    *
FROM
    person
WHERE
    address_street_name = 'Northwestern Dr'
ORDER BY
    address_number DESC
--
--
SELECT
    *
FROM
    interview
    INNER JOIN person ON interview.person_id = person.id
WHERE
    person.id = '16371'
    OR person.id = '14887'
--
--
SELECT
    *
FROM
    get_fit_now_member
WHERE
    id LIKE '48Z%'
    AND membership_status = 'gold'
--
--
SELECT
    *
FROM
    get_fit_now_member
    INNER JOIN person ON get_fit_now_member.person_id = person.id
WHERE
    get_fit_now_member.id LIKE '48Z%'
    AND membership_status = 'gold'
--
--
SELECT
    *
FROM
    get_fit_now_check_in
    JOIN get_fit_now_member ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE
    get_fit_now_member.id LIKE '48Z%'
    AND membership_status = 'gold'
--
--
SELECT
    *
FROM
    get_fit_now_member
    JOIN person ON get_fit_now_member.person_id = person.id
    JOIN drivers_license ON person.license_id = drivers_license.id
WHERE
    get_fit_now_member.id LIKE '48Z%'
    AND membership_status = 'gold'
INSERT INTO
    solution
VALUES
    (1, 'Jeremy Bowers');
--
--
SELECT
    value
FROM
    solution;


SELECT
    *
FROM
    interview
WHERE
    person_id = '67318'
-- 
--
SELECT
    *
FROM
    drivers_license
WHERE
    hair_color = 'red'
    AND height BETWEEN 65
    AND 67
    AND gender = 'female'
    AND car_model = 'Model S'
-- 
--     
SELECT
    *
FROM
    facebook_event_checkin
    JOIN person ON facebook_event_checkin.person_id = person.id
    JOIN drivers_license ON person.license_id = drivers_license.id
WHERE
    date LIKE '201712%'
    AND facebook_event_checkin.event_name = 'SQL Symphony Concert'
    AND hair_color = 'red'
    AND height BETWEEN 65
    AND 67
    AND gender = 'female'
    AND car_model = 'Model S'