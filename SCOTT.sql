-- SCOTT / TIGER ����

-- ���ӵ� ������ ���̺� ��ȸ
SELECT TABLE_NAME FROM TABS;

-- 4�� ���̺� ��ȸ
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;
SELECT * FROM BONUS;


-- �ڡڡڡڡ�
-- (1) GROUP BY : Ư�� �÷� �Ǵ� ����Ʋ �������� �����͸� �׷����� ����
--               (� �÷��� ����� ȿ�������� ����� �� ������ ����)
--               (�׷��� ���� �Ǹ� ���� �÷� �̿ܿ� �ٸ� �÷��� ��ȸ�� �Ұ�)

/*
    SELECT
    FROM
    WHERE
    GROUP BY [�׷�ȭ�� COLUMN�� ����]
    ORDER BY [������ COLUMN]
*/

-- �μ��� ��� �޿� ���ϱ�
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- EMP(EMPLOYEE : ����)
-- DEPT(DEPARTMENT : �μ�)
-- SAL(SALARY : �޿�, ����)
-- COMM(COMMISSION : ����)
-- LOC(LOCATION : ����)
-- GRADE (���)
-- LOSAL(LOW �����޿�)
-- HISAL(HIGH �ְ�޿�)

-- Q1. ����(JOB)���� �ο���, �޿��հ�, ��ձ޿��� ���Ͽ���.
SELECT JOB, COUNT(*) AS �ο���, SUM(SAL) AS �޿��հ�, ROUND(AVG(SAL)) AS ��ձ޿�
FROM EMP
GROUP BY JOB;

-- Q2. ����(JOB)�� �ο��� ���� ������ ����
SELECT JOB, COUNT(*) AS �ο���, SUM(SAL) AS �޿��հ�, ROUND(AVG(SAL)) AS ��ձ޿�
FROM EMP
GROUP BY JOB
ORDER BY COUNT(*) DESC;

-- (2) ROLLUP : �׷�ȭ �������� �հ踦 �Բ� ���
/*
    SELECT
    FROM
    WHERE
    GROUP BY ROLLUP([COL_NAME])
*/
SELECT JOB, COUNT(*) AS �ο���, SUM(SAL) AS �޿��հ�, ROUND(AVG(SAL)) AS ��ձ޿�
FROM EMP
GROUP BY ROLLUP(JOB);

-- �ڡڡڡڡ�
-- (3) HAVING : GROUP BY ���� ����ؼ� �׷�ȭ �� ��� ��
--              ��� �׷��� �����ϴ� ���ǽ�
/*
    SELECT
    FROM
    WHERE
    GROUP BY
    HAVING [��±׷��� �����ϴ� ���ǽ�] �ڡڡڡڡ�
    ORDER BY
*/

SELECT DEPTNO, COUNT(*)     -- �μ���ȣ, �ο����� �˻�
FROM EMP                    -- ���� ���̺���
WHERE SAL > 1500            -- �޿��� 1500���� ū ����
GROUP BY DEPTNO             -- �μ���ȣ���� ������
HAVING DEPTNO >= 20         -- �μ���ȣ 20 �̻��� �׷��߿���
ORDER BY DEPTNO ASC;        -- �μ���ȣ�� �����ͺ��� ���ʷ� ����

-- Q1. EMP���̺��� �μ���ȣ, ��ձ޿�, �ְ�޿�, �����޿�, ����� ��ȸ
--     �� ��� �޿��� ����� �� �Ҽ����� �����ϰ� �� �μ���ȣ ���� ���
SELECT DEPTNO, ROUND(AVG(SAL)), MAX(SAL), MIN(SAL), COUNT(*)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- Q2. �������޿� �����ϴ� ����� 3�� �̻��� ���ް� �ο��� ���
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
             
-- ��� �޿� �̻��λ����
SELECT * FROM EMP
WHERE SAL > (SELECT AVG(SAL) 
             FROM EMP);

-- �μ��� �ְ�޿�
SELECT DEPTNO,MAX(SAL)
FROM EMP
GROUP BY DEPTNO;

-- �μ��� �ְ�޿��� ����� ����
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

-- ���� �޿��� �����        
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
SELECT ENAME AS "�̸�", SAL AS "����"
FROM EMP;
--3
SELECT EMPNO AS "�����ȣ", ENAME AS "����̸�", SAL AS "����", SAL*12 AS "����"
FROM EMP;
--4
SELECT JOB
FROM EMP
GROUP BY JOB;
--5
SELECT  ENAME AS "����̸�", SAL*12 AS "����"
FROM EMP;
--6
SELECT INITCAP(ENAME), LENGTH(INITCAP(ENAME))
FROM EMP;


7. ����(COMM)�� �ް� �޿��� 1,600�̻��� ����� ����̸�, �μ���, �ٹ����� ����Ͻÿ�.
SELECT
*
FROM EMP;

SELECT
ENAME,JOB,LOC
FROM EMP INNER JOIN DEPT ON DEPT.DEPTNO=EMP.DEPTNO
WHERE COMM + SAL >= 1600;
8. �ٹ������� �ٹ��ϴ� ����� ���� 5�� ������ ���, �ο��� ���� ���� ������ �����Ͻÿ�.
  (�ٹ� �ο��� 0���� ���� ǥ��);
SELECT * FROM DEPT;  
SELECT * FROM EMP;

SELECT
COUNT(EMPNO),LOC
FROM EMP RIGHT OUTER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY LOC
HAVING COUNT(LOC)<=5 ORDER BY COUNT(LOC);

9. �ѱ޿�(SAL+COMM)�� ��� �޿����� ���� �޿��� �޴� ����� �μ���ȣ, �̸�, �ѱ޿�, ������ 
    ����Ͻÿ�.(������ ��(O),��(X)�� ǥ���ϰ� �÷����� "COMM����" ���);

SELECT
   *
FROM EMP;
SELECT
DEPTNO AS �μ���ȣ ,ENAME AS �̸�,(SAL+NVL(COMM,0)) AS �ѱ޿�,NVL2(COMM,'��(O)','��(X)') AS COMM����
FROM EMP
WHERE (SAL+NVL(COMM,0)) >(SELECT AVG(SAL) FROM EMP);

10. 20�� �μ����� ���� �޿��� ���� �޴� ����� ������ �޿��� �޴� ����� 
   �̸��� �μ���, �޿�, �޿������ ����Ͻÿ�.(EMP, DEPT, SALGRADE ���̺� ���);

SELECT * FROM SALGRADE;
SELECT * FROM EMP;

SELECT ENAME,DNAME,SAL,GRADE 
FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
         INNER JOIN SALGRADE ON salgrade.losal <= SAL AND salgrade.hisal >= SAL
WHERE SAL IN (SELECT MAX(SAL)
              FROM EMP
              WHERE DEPTNO=20);










