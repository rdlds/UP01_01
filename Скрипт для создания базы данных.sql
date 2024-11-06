-- 1. ������� ��� �������� ��������� �������� ������
CREATE TABLE RequestStatus (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name NVARCHAR(50) NOT NULL UNIQUE
);

-- 2. ������� ��� �������� ������ � ��������
CREATE TABLE Client (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    contact_info NVARCHAR(255)
);

-- 3. ������� ��� ������������
CREATE TABLE Equipment (
    equipment_id INT IDENTITY(1,1) PRIMARY KEY,
    serial_number NVARCHAR(50) NOT NULL UNIQUE,
    type NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

-- 4. ������� ��� ������ �� ������
CREATE TABLE RepairRequest (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    request_number NVARCHAR(50) UNIQUE NOT NULL,
    creation_date DATE NOT NULL,
    equipment_id INT NOT NULL,
    issue_type NVARCHAR(100),
    description NVARCHAR(MAX),
    client_id INT NOT NULL,
    current_status_id INT,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (current_status_id) REFERENCES RequestStatus(status_id)
);

-- 5. ������� ��� ����������� (������������ ������)
CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    position NVARCHAR(100),
    contact_info NVARCHAR(255)
);

-- 6. ������� ��� ���������� ����������� � ������
CREATE TABLE RequestAssignment (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    employee_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    FOREIGN KEY (request_id) REFERENCES RepairRequest(request_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- 7. ������� ��� ������� ��������� �������� ������ � ���������� ������������
CREATE TABLE RequestLog (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    log_date DATETIME DEFAULT GETDATE(),
    status_id INT,
    comment NVARCHAR(MAX),
    employee_id INT,
    FOREIGN KEY (request_id) REFERENCES RepairRequest(request_id),
    FOREIGN KEY (status_id) REFERENCES RequestStatus(status_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
-- ���������� ������� ��������
INSERT INTO RequestStatus (status_name)
VALUES ('� ��������'), ('� ������'), ('���������'), ('��������');
-- ������ ���������� ������� ��������
INSERT INTO Client (name, contact_info)
VALUES 
    ('��� ������������', 'contact@repairservice.com'),
    ('�� ������', 'ivanov@example.com'),
    ('��� ������������', 'equipment@zno.ru'),
    ('�� ��������', 'kuznetsov@mail.com'),
    ('��� �����', 'techno@teh.ru');

-- ������ ���������� ������� ������������
INSERT INTO Equipment (serial_number, type, description)
VALUES 
    ('SN12345', '������', '������ ��� ��������� �������'),
    ('SN67890', '����������', '��������� ����������'),
    ('SN54321', '�����', '����� ��� ��������� ���������'),
    ('SN98765', '���������', '���������������� �� ��������� �������'),
    ('SN11223', '����', '��������� ���� ��� ������������ �����');

-- ������ ���������� ������� �����������
INSERT INTO Employee (name, position, contact_info)
VALUES 
    ('������ ����', '�������', 'petrov@company.com'),
    ('������� ����', '������', 'sidorov@company.com'),
    ('�������� ����', '������', 'kuznetsov@company.com'),
    ('������� �����', '�������', 'ivanova@company.com'),
    ('������� ������', '�������', 'smirnov@company.com');

-- ������ ���������� ������� ������ �� ������
INSERT INTO RepairRequest (request_number, creation_date, equipment_id, issue_type, description, client_id, current_status_id)
VALUES 
    ('RQ10001', '2024-01-10', 1, '�������', '������������� ������', 1, 1),
    ('RQ10002', '2024-01-15', 2, '����', '������������� �����������', 2, 1),
    ('RQ10003', '2024-01-20', 3, '����', '���� � ������', 3, 2),
    ('RQ10004', '2024-02-01', 4, '����� �������', '��������� �� �����������', 4, 1),
    ('RQ10005', '2024-02-05', 5, '�������������', '���� �� ���������', 5, 1);
