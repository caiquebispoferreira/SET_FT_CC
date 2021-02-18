/*
#301093125 - Caique Bispo Ferreira
*/

/*
1. List the name of each officer  
who has reported more than the average number of crimes officers have reported.
*/
SELECT FIRST, LAST
FROM OFFICERS
JOIN 
(
    SELECT OFFICER_ID, COUNT(*) NUMBER_OF_CRIMES
    FROM CRIME_OFFICERS
    GROUP BY OFFICER_ID
) using(OFFICER_ID)
WHERE NUMBER_OF_CRIMES >
    (
        SELECT AVG(NUMBER_OF_CRIMES)
        FROM (
            SELECT OFFICER_ID, COUNT(*) NUMBER_OF_CRIMES
            FROM CRIME_OFFICERS
            GROUP BY OFFICER_ID
        ) 
    );

/*
2. List the names of all criminals  - OK
who have committed less than average number of crimes and  - OK
aren’t listed as violent offenders. ???
*/
SELECT FIRST, LAST
FROM CRIMINALS
JOIN 
(   SELECT CRIMINAL_ID, COUNT(*) NUMBER_OF_CRIMES
    FROM CRIMES
    GROUP BY CRIMINAL_ID
) using(CRIMINAL_ID)
WHERE V_STATUS = 'N' AND NUMBER_OF_CRIMES <
    (
        SELECT AVG(NUMBER_OF_CRIMES)
        FROM (
                SELECT CRIMINAL_ID, COUNT(*) NUMBER_OF_CRIMES
                FROM CRIMES
                GROUP BY CRIMINAL_ID
             ) 
    );
    
    
/*
3. List appeal information for each appeal 
that has a less than average number of days between the filing and hearing dates.
*/

SELECT APPEAL_ID, CRIME_ID, FILING_DATE, HEARING_DATE, STATUS
FROM APPEALS
WHERE (HEARING_DATE - FILING_DATE) < (
                                SELECT AVG(HEARING_DATE - FILING_DATE) AVG
                                FROM APPEALS
                                );
                                
/*
4. List the names of probation officers 
who have had a less than average number of criminals assigned.
*/
SELECT FIRST, LAST , NUMBER_OF_CRIMES
FROM OFFICERS
JOIN (
        SELECT OFFICER_ID, COUNT(*) NUMBER_OF_CRIMES
        FROM CRIME_OFFICERS
        GROUP BY OFFICER_ID)
USING (OFFICER_ID)
WHERE NUMBER_OF_CRIMES < (
    SELECT AVG(NUMBER_OF_CRIMES)
    FROM (
        SELECT OFFICER_ID, COUNT(*) NUMBER_OF_CRIMES
        FROM CRIME_OFFICERS
        GROUP BY OFFICER_ID
    )
);

/*
5. List each crime that has had the highest number of appeals recorded.
*/

SELECT CRIME_ID, CRIMINAL_ID, CLASSIFICATION, DATE_CHARGED, STATUS, HEARING_DATE, APPEAL_CUT_DATE, DATE_RECORDED  
FROM CRIMES
WHERE CRIME_ID IN (
    SELECT CRIME_ID 
    FROM (
        SELECT CRIME_ID, COUNT(*) NUMBER_OF_APPEALS
        FROM APPEALS
        GROUP BY CRIME_ID)
    WHERE NUMBER_OF_APPEALS = (
        SELECT NUMBER_OF_APPEALS
        FROM (
            SELECT CRIME_ID, COUNT(*) NUMBER_OF_APPEALS
            FROM APPEALS
            WHERE ROWNUM = 1
            GROUP BY CRIME_ID
            ORDER BY 2
        ) -- the highest number of appeals recorded
    )
);
