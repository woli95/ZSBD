USE SportCenter
GO
INSERT INTO discount VALUES
	('More than one', 0.05),
	('Regular customer', 0.10),
	('Golden customer', 0.15),
	('Top customer', 0.20)
INSERT INTO client VALUES
	('Dawid', 'Wolszczak', '507309173', NULL),
	('Krzysztof', 'Jarzyna', '508007040', NULL),
	('Donald', 'Tusk', '581920344', 4),
	('Zbigniew', 'Stonoga', '997102939', 2)
INSERT INTO status VALUES 
	('Confirmed'),
	('Paid'),
	('Cancelled'),
	('Completed')
INSERT INTO fee VALUES
	('Mess fee', 100),
	('Destruction of the goal', 6500),
	('Destruction of the goal net', 200)
INSERT INTO caretaker VALUES
	('Waldemar', 'Pieczatka', 504091840),
	('Boleslaw', 'Kowalski', 511001319),
	('Katarzyna', 'Wichopek', 680129011),
	('Michal', 'Durszlak', 718445811)
INSERT INTO facility VALUES
	('Football grass field', 220, 1),
	('Street football field', 100, 1),
	('Football hall', 120, 2)
INSERT INTO reservation VALUES
    (1, 1, GETDATE(), '2021-03-23 07:00', 2, 1, NULL),
    (2, 1, GETDATE(), '2021-03-23 10:00', 1, 1, NULL),
    (3, 1, GETDATE(), '2021-03-23 15:00', 5, 1, NULL)
