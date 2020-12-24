-- SCOTT / TIGER 계정

-- 접속된 계정의 테이블 조회
SELECT TABLE_NAME FROM TABS;

-- 4개 테이블 조회
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;
SELECT * FROM BONUS;


-- ★★★★★
-- (1) GROUP BY : 특정 컬럼 또는 데이틀 기준으로 데이터를 그룹으로 묶음
--               (어떤 컬럼을 묶어야 효율적으로 사용할 수 있을지 생각)
--               (그룹을 묶게 되면 기준 컬럼 이외에 다른 컬럼은 조회가 불가)

/*
    SELECT
    FROM
    WHERE
    GROUP BY [그룹화할 COLUMN을 지정]
    ORDER BY [정렬할 COLUMN]
*/

-- 부서별 평균 급여 구하기
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- EMP(EMPLOYEE : 직원)
-- DEPT(DEPARTMENT : 부서)
-- SAL(SALARY : 급여, 월급)
-- COMM(COMMISSION : 수당)
-- LOC(LOCATION : 지역)
-- GRADE (등급)
-- LOSAL(LOW 최저급여)
-- HISAL(HIGH 최고급여)

-- Q1. 직급(JOB)별로 인원수, 급여합계, 평균급여를 구하여라.
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY JOB;

-- Q2. 직급(JOB)별 인원이 많은 순으로 정렬
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY JOB
ORDER BY COUNT(*) DESC;

-- (2) ROLLUP : 그룹화 데이터의 합계를 함께 출력
/*
    SELECT
    FROM
    WHERE
    GROUP BY ROLLUP([COL_NAME])
*/
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY ROLLUP(JOB);

-- ★★★★★
-- (3) HAVING : GROUP BY 절을 사용해서 그룹화 된 결과 중
--              출력 그룹을 선별하는 조건식
/*
    SELECT
    FROM
    WHERE
    GROUP BY
    HAVING [출력그룹을 제한하는 조건식] ★★★★★
    ORDER BY
*/

SELECT DEPTNO, COUNT(*)     -- 부서번호, 인원수를 검색
FROM EMP                    -- 직원 테이블에서
WHERE SAL > 1500            -- 급여가 1500보다 큰 것을
GROUP BY DEPTNO             -- 부서번호별로 나눠서
HAVING DEPTNO >= 20         -- 부서번호 20 이상인 그룹중에서
ORDER BY DEPTNO ASC;        -- 부서번호가 작은것부터 차례로 정렬

-- Q1. EMP테이블에서 부서번호, 평균급여, 최고급여, 최저급여, 사원수 조회
--     단 평균 급여를 출력할 때 소숫점을 제외하고 각 부서번호 별로 출력
SELECT DEPTNO, ROUND(AVG(SAL)), MAX(SAL), MIN(SAL), COUNT(*)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- Q2. 같은직급에 종사하는 사원이 3명 이상인 직급과 인원수 출력
SELECT JOB, COUNT(*)
FROM EMP
GROUP BY JOB
HAVING COUNT(*) >= 3;

SELECT
   *
FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT SAL
FROM EMP
WHERE ENAME = 'JONES';

SELECT * FROM EMP
WHERE SAL >2975;

SELECT * FROM EMP
WHERE SAL > (SELECT SAL 
             FROM EMP 
             WHERE ENAME = 'JONES');
             
-- 평균 급여 이상인사람들
SELECT * FROM EMP
WHERE SAL > (SELECT AVG(SAL) 
             FROM EMP);

-- 부서별 최고급여
SELECT DEPTNO,MAX(SAL)
FROM EMP
GROUP BY DEPTNO;

-- 부서별 최고급여인 사람들 정보
SELECT * 
FROM EMP 
WHERE (DEPTNO,SAL) IN(SELECT DEPTNO ,MAX(SAL)
                      FROM EMP
                      GROUP BY DEPTNO);
SELECT *
FROM EMP 
WHERE SAL IN (SELECT MAX(SAL) 
              FROM EMP 
              GROUP BY DEPTNO);

-- 동일 급여인 사람들        
SELECT M.*
FROM EMP M,EMP E
WHERE M.SAL = E.SAL AND M.EMPNO != E.EMPNO;
SELECT M.*
FROM EMP M,EMP E
WHERE M.SAL = E.SAL AND M.EMPNO != E.EMPNO;
SELECT *
FROM EMP M
WHERE EXISTS (SELECT *
              FROM EMP S 
              WHERE S.EMPNO != M.EMPNO);
--1
SELECT EMPNO, ENAME, SAL
FROM EMP;
--2
SELECT ENAME AS "이름", SAL AS "월급"
FROM EMP;
--3
SELECT EMPNO AS "사원번호", ENAME AS "사원이름", SAL AS "월급", SAL*12 AS "연봉"
FROM EMP;
--4
SELECT JOB
FROM EMP
GROUP BY JOB;
--5
SELECT  ENAME AS "사원이름", SAL*12 AS "연봉"
FROM EMP;
--6
SELECT INITCAP(ENAME), LENGTH(INITCAP(ENAME))
FROM EMP;


7. 수당(COMM)을 받고 급여가 1,600이상인 사원의 사원이름, 부서명, 근무지를 출력하시오.
SELECT
*
FROM EMP;

SELECT
ENAME,JOB,LOC
FROM EMP INNER JOIN DEPT ON DEPT.DEPTNO=EMP.DEPTNO
WHERE COMM + SAL >= 1600;
8. 근무지별로 근무하는 사원의 수가 5명 이하인 경우, 인원이 적은 도시 순으로 정렬하시오.
  (근무 인원이 0명인 곳도 표시);
SELECT * FROM DEPT;  
SELECT * FROM EMP;

SELECT
COUNT(EMPNO),LOC
FROM EMP RIGHT OUTER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY LOC
HAVING COUNT(LOC)<=5 ORDER BY COUNT(LOC);

9. 총급여(SAL+COMM)가 평균 급여보다 많은 급여를 받는 사람의 부서번호, 이름, 총급여, 수당을 
    출력하시오.(수당은 유(O),무(X)로 표시하고 컬럼명은 "COMM유무" 출력);

SELECT
   *
FROM EMP;
SELECT
DEPTNO AS 부서번호 ,ENAME AS 이름,(SAL+NVL(COMM,0)) AS 총급여,NVL2(COMM,'유(O)','무(X)') AS COMM유무
FROM EMP
WHERE (SAL+NVL(COMM,0)) >(SELECT AVG(SAL) FROM EMP);

10. 20번 부서에서 가장 급여를 많이 받는 사원과 동일한 급여를 받는 사원의 
   이름과 부서명, 급여, 급여등급을 출력하시오.(EMP, DEPT, SALGRADE 테이블 사용);

SELECT * FROM SALGRADE;
SELECT * FROM EMP;

SELECT ENAME,DNAME,SAL,GRADE 
FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
         INNER JOIN SALGRADE ON salgrade.losal <= SAL AND salgrade.hisal >= SAL
WHERE SAL IN (SELECT MAX(SAL)
              FROM EMP
              WHERE DEPTNO=20);










