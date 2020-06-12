CREATE USER [parameters_reader]
    WITH PASSWORD = N'YOUR_PASSWORD_HERE';
GO

GRANT SELECT
    ON SCHEMA::[survey] TO [parameters_reader];
GO