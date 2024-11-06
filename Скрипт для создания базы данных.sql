-- 1. Таблица для хранения возможных статусов заявок
CREATE TABLE RequestStatus (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name NVARCHAR(50) NOT NULL UNIQUE
);

-- 2. Таблица для хранения данных о клиентах
CREATE TABLE Client (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    contact_info NVARCHAR(255)
);

-- 3. Таблица для оборудования
CREATE TABLE Equipment (
    equipment_id INT IDENTITY(1,1) PRIMARY KEY,
    serial_number NVARCHAR(50) NOT NULL UNIQUE,
    type NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

-- 4. Таблица для заявок на ремонт
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

-- 5. Таблица для сотрудников (исполнителей заявок)
CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    position NVARCHAR(100),
    contact_info NVARCHAR(255)
);

-- 6. Таблица для назначения исполнителя к заявке
CREATE TABLE RequestAssignment (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    employee_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    FOREIGN KEY (request_id) REFERENCES RepairRequest(request_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- 7. Таблица для истории изменений статусов заявок и добавления комментариев
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
-- Заполнение таблицы статусов
INSERT INTO RequestStatus (status_name)
VALUES ('В ожидании'), ('В работе'), ('Выполнено'), ('Отменено');
-- Пример заполнения таблицы клиентов
INSERT INTO Client (name, contact_info)
VALUES 
    ('ООО РемонтСервис', 'contact@repairservice.com'),
    ('ИП Иванов', 'ivanov@example.com'),
    ('ЗАО Оборудование', 'equipment@zno.ru'),
    ('ФЛ Кузнецов', 'kuznetsov@mail.com'),
    ('ООО Техно', 'techno@teh.ru');

-- Пример заполнения таблицы оборудования
INSERT INTO Equipment (serial_number, type, description)
VALUES 
    ('SN12345', 'Станок', 'Станок для обработки металла'),
    ('SN67890', 'Компрессор', 'Воздушный компрессор'),
    ('SN54321', 'Насос', 'Насос для перекачки жидкостей'),
    ('SN98765', 'Генератор', 'Электрогенератор на дизельном топливе'),
    ('SN11223', 'Кран', 'Подъемный кран для строительных работ');

-- Пример заполнения таблицы сотрудников
INSERT INTO Employee (name, position, contact_info)
VALUES 
    ('Петров Петр', 'Инженер', 'petrov@company.com'),
    ('Сидоров Иван', 'Мастер', 'sidorov@company.com'),
    ('Кузнецов Олег', 'Техник', 'kuznetsov@company.com'),
    ('Иванова Мария', 'Инженер', 'ivanova@company.com'),
    ('Смирнов Андрей', 'Слесарь', 'smirnov@company.com');

-- Пример заполнения таблицы заявок на ремонт
INSERT INTO RepairRequest (request_number, creation_date, equipment_id, issue_type, description, client_id, current_status_id)
VALUES 
    ('RQ10001', '2024-01-10', 1, 'Поломка', 'Неисправность станка', 1, 1),
    ('RQ10002', '2024-01-15', 2, 'Сбой', 'Неисправность компрессора', 2, 1),
    ('RQ10003', '2024-01-20', 3, 'Течь', 'Течь в насосе', 3, 2),
    ('RQ10004', '2024-02-01', 4, 'Отказ запуска', 'Генератор не запускается', 4, 1),
    ('RQ10005', '2024-02-05', 5, 'Неисправность', 'Кран не поднимает', 5, 1);
