USE master;
GO
DROP DATABASE IF EXISTS VolunteerNetwork;
GO
CREATE DATABASE VolunteerNetwork;
GO
USE VolunteerNetwork;
GO


CREATE TABLE Volunteers
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Events
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
) AS NODE;

CREATE TABLE Cities
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(30) NOT NULL
) AS NODE;

-- ������� ����: Knows (������ �)
CREATE TABLE Knows AS EDGE;

-- ������� ����: ParticipatesIn (��������� �)
CREATE TABLE ParticipatesIn AS EDGE;

-- ������� ����: HeldIn (���������� �)
CREATE TABLE HeldIn (
    event_date DATE -- ���� ���������� �����������
) AS EDGE;

-- ���������� ����������� ����
ALTER TABLE Knows
ADD CONSTRAINT EC_Knows CONNECTION (Volunteers TO Volunteers);

ALTER TABLE ParticipatesIn
ADD CONSTRAINT EC_ParticipatesIn CONNECTION (Volunteers TO Events);

ALTER TABLE HeldIn
ADD CONSTRAINT EC_HeldIn CONNECTION (Events TO Cities);
GO

INSERT INTO Volunteers (id, name)
VALUES 
    (1, N'����'),
    (2, N'����'),
    (3, N'�����'),
    (4, N'����'),
    (5, N'�����'),
    (6, N'�������'),
    (7, N'�����'),
    (8, N'�������'),
    (9, N'����'),
    (10, N'�����');

INSERT INTO Events (id, name)
VALUES 
    (1, N'���-���������'),
    (2, N'����������������� �������'),
    (3, N'���� ������'),
    (4, N'��������� ������� ���'),
    (5, N'������ �����'),
    (6, N'������� ��� �����'),
    (7, N'����������'),
    (8, N'������� �����'),
    (9, N'������������'),
    (10, N'������-����� �� ���������');

INSERT INTO Cities (id, name, region)
VALUES 
    (1, N'������', N'���������� �������'),
    (2, N'�����-���������', N'������������� �������'),
    (3, N'������������', N'������������ �������'),
    (4, N'�����������', N'������������� �������'),
    (5, N'������', N'���������'),
    (6, N'������ ��������', N'������������� �������'),
    (7, N'������-��-����', N'���������� �������'),
    (8, N'����������', N'������������ ����'),
    (9, N'������', N'��������� �������'),
    (10, N'�����������', N'���������� ����');
GO


-- ���������� ������� Knows (���������� ����� ����������)
INSERT INTO Knows ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Volunteers WHERE id = 1), (SELECT $node_id FROM Volunteers WHERE id = 2)), -- ���� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 1), (SELECT $node_id FROM Volunteers WHERE id = 3)), -- ���� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 2), (SELECT $node_id FROM Volunteers WHERE id = 4)), -- ���� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 3), (SELECT $node_id FROM Volunteers WHERE id = 5)), -- ����� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 4), (SELECT $node_id FROM Volunteers WHERE id = 6)), -- ���� ����� �������
    ((SELECT $node_id FROM Volunteers WHERE id = 5), (SELECT $node_id FROM Volunteers WHERE id = 7)), -- ����� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 6), (SELECT $node_id FROM Volunteers WHERE id = 8)), -- ������� ����� �������
    ((SELECT $node_id FROM Volunteers WHERE id = 7), (SELECT $node_id FROM Volunteers WHERE id = 9)), -- ����� ����� ����
    ((SELECT $node_id FROM Volunteers WHERE id = 8), (SELECT $node_id FROM Volunteers WHERE id = 10)), -- ������� ����� �����
    ((SELECT $node_id FROM Volunteers WHERE id = 9), (SELECT $node_id FROM Volunteers WHERE id = 3)); -- ���� ����� �����

-- ���������� ������� ParticipatesIn (������� ��������� � ������������)
INSERT INTO ParticipatesIn ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Volunteers WHERE id = 1), (SELECT $node_id FROM Events WHERE id = 1)), -- ���� �� ���-���������
    ((SELECT $node_id FROM Volunteers WHERE id = 1), (SELECT $node_id FROM Events WHERE id = 5)), -- ���� �� ������ ������
    ((SELECT $node_id FROM Volunteers WHERE id = 2), (SELECT $node_id FROM Events WHERE id = 2)), -- ���� �� ��������
    ((SELECT $node_id FROM Volunteers WHERE id = 3), (SELECT $node_id FROM Events WHERE id = 3)), -- ����� �� ��� ������
    ((SELECT $node_id FROM Volunteers WHERE id = 4), (SELECT $node_id FROM Events WHERE id = 4)), -- ���� �� ��������� ���
    ((SELECT $node_id FROM Volunteers WHERE id = 5), (SELECT $node_id FROM Events WHERE id = 6)), -- ����� �� ��������
    ((SELECT $node_id FROM Volunteers WHERE id = 6), (SELECT $node_id FROM Events WHERE id = 7)), -- ������� �� �����������
    ((SELECT $node_id FROM Volunteers WHERE id = 7), (SELECT $node_id FROM Events WHERE id = 8)), -- ����� �� ������� ������
    ((SELECT $node_id FROM Volunteers WHERE id = 8), (SELECT $node_id FROM Events WHERE id = 9)), -- ������� �� ������������
    ((SELECT $node_id FROM Volunteers WHERE id = 9), (SELECT $node_id FROM Events WHERE id = 10)), -- ���� �� ������-������
    ((SELECT $node_id FROM Volunteers WHERE id = 10), (SELECT $node_id FROM Events WHERE id = 1)); -- ����� �� ���-���������

-- ���������� ������� HeldIn
INSERT INTO HeldIn ($from_id, $to_id, event_date)
VALUES 
    -- ���-��������� �������� � ������ � �����-����������
    ((SELECT $node_id FROM Events WHERE id = 1), (SELECT $node_id FROM Cities WHERE id = 1), '2025-06-01'), -- ���-��������� � ������
    ((SELECT $node_id FROM Events WHERE id = 1), (SELECT $node_id FROM Cities WHERE id = 2), '2025-06-15'), -- ���-��������� � ���
    
    -- ������� �������� � �����-���������� � ������
    ((SELECT $node_id FROM Events WHERE id = 2), (SELECT $node_id FROM Cities WHERE id = 2), '2025-07-15'), -- ������� � ���
    ((SELECT $node_id FROM Events WHERE id = 2), (SELECT $node_id FROM Cities WHERE id = 5), '2025-07-20'), -- ������� � ������
    
    -- ���� ������ � �������������
    ((SELECT $node_id FROM Events WHERE id = 3), (SELECT $node_id FROM Cities WHERE id = 3), '2025-08-10'), -- ���� ������ � �������������
    
    -- ��������� ��� �������� � ������������ � ������
    ((SELECT $node_id FROM Events WHERE id = 4), (SELECT $node_id FROM Cities WHERE id = 4), '2025-09-05'), -- ��������� ��� � ������������
    ((SELECT $node_id FROM Events WHERE id = 4), (SELECT $node_id FROM Cities WHERE id = 1), '2025-09-10'), -- ��������� ��� � ������
    
    -- ������ ����� � ������ � �������
    ((SELECT $node_id FROM Events WHERE id = 5), (SELECT $node_id FROM Cities WHERE id = 5), '2025-10-20'), -- ������ ����� � ������
    ((SELECT $node_id FROM Events WHERE id = 5), (SELECT $node_id FROM Cities WHERE id = 7), '2025-10-25'), -- ������ ����� � �������
    
    -- ������� � ������ ��������� � ������
    ((SELECT $node_id FROM Events WHERE id = 6), (SELECT $node_id FROM Cities WHERE id = 6), '2025-11-12'), -- ������� � ������ ���������
    ((SELECT $node_id FROM Events WHERE id = 6), (SELECT $node_id FROM Cities WHERE id = 9), '2025-11-15'), -- ������� � ������
    
    -- ���������� � �������
    ((SELECT $node_id FROM Events WHERE id = 7), (SELECT $node_id FROM Cities WHERE id = 7), '2025-12-01'), -- ���������� � �������
    
    -- ������� ����� � ����������� � ������
    ((SELECT $node_id FROM Events WHERE id = 8), (SELECT $node_id FROM Cities WHERE id = 8), '2026-01-15'), -- ������� ����� � �����������
    ((SELECT $node_id FROM Events WHERE id = 8), (SELECT $node_id FROM Cities WHERE id = 1), '2026-01-20'), -- ������� ����� � ������
    
    -- ������������ � ������
    ((SELECT $node_id FROM Events WHERE id = 9), (SELECT $node_id FROM Cities WHERE id = 9), '2026-02-10'), -- ������������ � ������
    
    -- ������-����� �� ������������ � �����-����������
    ((SELECT $node_id FROM Events WHERE id = 10), (SELECT $node_id FROM Cities WHERE id = 10), '2026-03-05'), -- ������-����� �� ������������
    ((SELECT $node_id FROM Events WHERE id = 10), (SELECT $node_id FROM Cities WHERE id = 2), '2026-03-10'); -- ������-����� � ���
GO

-- 1. ��� ������ � �����?
SELECT V1.name AS Volunteer, V2.name AS Friend
FROM Volunteers AS V1, Knows, Volunteers AS V2
WHERE MATCH(V1-(Knows)->V2)
AND V1.name = N'����';

-- 2. ����� ����������� �������� �������� ����?
SELECT V2.name AS Friend, E.name AS Event
FROM Volunteers AS V1, Volunteers AS V2, Knows, ParticipatesIn, Events AS E
WHERE MATCH(V1-(Knows)->V2-(ParticipatesIn)->E)
AND V1.name = N'����';

-- 3. � ����� ������� �������� �����������, � ������� ��������� ����?
SELECT E.name AS Event, C.name AS City
FROM Volunteers AS V, ParticipatesIn, Events AS E, HeldIn, Cities AS C
WHERE MATCH(V-(ParticipatesIn)->E-(HeldIn)->C)
AND V.name = N'����';

-- 4. ��� ��������� � ������������ � ������?
SELECT V.name AS Volunteer, E.name AS Event
FROM Volunteers AS V, ParticipatesIn, Events AS E, HeldIn, Cities AS C
WHERE MATCH(V-(ParticipatesIn)->E-(HeldIn)->C)
AND C.name = N'������';

--5: ����� �������� ��������� � ������������, ���������� � ����� ������ � �����?
SELECT DISTINCT V2.name AS Volunteer, E2.name AS Event, C.name AS City
FROM Volunteers AS V1, Volunteers AS V2, ParticipatesIn AS P1, ParticipatesIn AS P2, Events AS E1, Events AS E2, HeldIn AS H1, HeldIn AS H2, Cities AS C
WHERE MATCH(V1-(P1)->E1-(H1)->C<-(H2)-E2<-(P2)-V2)
AND V1.name = N'����'
AND V1.id != V2.id;


-- 1. ����� ���������� ���� �� ���� �� ���� ��������� ����� ���������� (������ +)
SELECT V1.name AS Volunteer, 
       STRING_AGG(V2.name, '->') WITHIN GROUP (GRAPH PATH) AS ConnectionPath
FROM Volunteers AS V1, 
     Knows FOR PATH AS K, 
     Volunteers FOR PATH AS V2
WHERE MATCH(SHORTEST_PATH(V1(-(K)->V2)+))
AND V1.name = N'����';

-- 2. ����� ���������� ���� �� ����� �� ��������� �� ������� �� ����� 3 ����� (������ {1,3})
SELECT V1.name AS Volunteer, 
       STRING_AGG(V2.name, '->') WITHIN GROUP (GRAPH PATH) AS ConnectionPath
FROM Volunteers AS V1, 
     Knows FOR PATH AS K, 
     Volunteers FOR PATH AS V2
WHERE MATCH(SHORTEST_PATH(V1(-(K)->V2){1,3}))
AND V1.name = N'����';

