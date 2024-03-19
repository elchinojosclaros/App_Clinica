create database DB_Clinica2
on primary
(
name=DB_Clinica_Data,
filename='D:\programas\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_Clinica_Data.mdf',
size=5mb,
maxsize=unlimited,
filegrowth=10%
)
log on
(
name=DB_Clinica_Log,
filename='D:\programas\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_Clinica_Log.ldf',
size=5mb,
maxsize=unlimited,
filegrowth=10%
)
GO

USE DB_Clinica2
GO

-- CREAR TABLAS

CREATE TABLE EECC
(
    EECCCodigo tinyint IDENTITY PRIMARY KEY NOT NULL,
    EECCDescripcion varchar(10)
);

INSERT INTO EECC VALUES ('Soltero'),('Casado'),('Viudo'),('Divorciado');

CREATE TABLE Genero
(
    GeneroCCodigo tinyint IDENTITY PRIMARY KEY NOT NULL,
    GeneroDescripcion varchar(9)
);

INSERT INTO Genero VALUES ('Femenino'),('Masculino');

CREATE TABLE Paciente
(
    PacienteCodigo varchar(8) PRIMARY KEY NOT NULL,
    PacienteNombre varchar(30),
    PacienteApellido varchar(50),
    PacienteDireccion varchar(150),
    PacienteTelefono int,
    PacienteNacimiento date,
    EECCCodigo tinyint FOREIGN KEY REFERENCES EECC(EECCCodigo),
    GeneroCCodigo tinyint FOREIGN KEY REFERENCES Genero(GeneroCCodigo)
);

CREATE TABLE HHCC
(
    HHCCCodigo int IDENTITY(10000,2) PRIMARY KEY NOT NULL,
    HHCCFecha datetime,
    PacienteCodigo varchar(8) FOREIGN KEY REFERENCES Paciente(PacienteCodigo)
);

CREATE TABLE Especialidad
(
    EspecialidadCodigo int IDENTITY PRIMARY KEY NOT NULL,
    EspecialidadDescripcion varchar(50)
);

INSERT INTO Especialidad VALUES ('Traumotología'),('Rayos X'),('Odontología'),('Obstetricia'),('oftalmología');

CREATE TABLE Especialista
(
    EspecialistaCMP int PRIMARY KEY NOT NULL,
    EspecialistaNombre varchar(30),
    EspecialistaApellido varchar(50),
    EspecialidadCodigo int FOREIGN KEY REFERENCES Especialidad(EspecialidadCodigo)
);

CREATE TABLE ActoMedico
(
    ActoMedicoCodigo int IDENTITY PRIMARY KEY NOT NULL,
    ActoMedicoFecha datetime,
    HHCCCodigo int FOREIGN KEY REFERENCES HHCC(HHCCCodigo),
    EspecialistaCMP int FOREIGN KEY REFERENCES Especialista(EspecialistaCMP),
    ActoMedicoObservacion varchar(250)
);

DROP TABLE IF EXISTS ActoMedicoDetalle; -- Eliminar la tabla si existe

CREATE TABLE ActoMedicoDetalle
(
    ActoMedicoCodigo int FOREIGN KEY REFERENCES ActoMedico(ActoMedicoCodigo),
    fiebre float,
    tos bit,
    dolorCabeza bit,
    dolorMusculares bit,
    malestarGeneral bit,
    dolorGarganta bit,
    secreciónNasal bit
);

-- PROCEDIMIENTO ALMACENADO

CREATE PROCEDURE usp_InsertarPaciente
(
    @PacienteCodigo varchar(8),
    @PacienteNombre varchar(30),
    @PacienteApellido varchar(50),
    @PacienteDireccion varchar(150),
    @PacienteTelefono int,
    @PacienteNacimiento date,
    @EECCCodigo tinyint,
    @GeneroCCodigo tinyint
)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Paciente
        (
            PacienteCodigo,
            PacienteNombre,
            PacienteApellido,
            PacienteDireccion,
            PacienteTelefono,
            PacienteNacimiento,
            EECCCodigo,
            GeneroCCodigo
        )
        VALUES
        (
            @PacienteCodigo,
            @PacienteNombre,
            @PacienteApellido,
            @PacienteDireccion,
            @PacienteTelefono,
            @PacienteNacimiento,
            @EECCCodigo,
            @GeneroCCodigo
        );
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;

CREATE PROCEDURE usp_EliminarPaciente
(
    @PacienteCodigo varchar(8)
)
AS
BEGIN
    BEGIN TRY
        DELETE FROM Paciente
        WHERE PacienteCodigo = @PacienteCodigo;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;

CREATE PROCEDURE usp_ActualizarPaciente
(
    @PacienteCodigo varchar(8),
    @PacienteNombre varchar(30),
    @PacienteApellido varchar(50),
    @PacienteDireccion varchar(150),
    @PacienteTelefono int,
    @PacienteNacimiento date,
    @EECCCodigo tinyint,
    @GeneroCCodigo tinyint
)
AS
BEGIN
    BEGIN TRY
        UPDATE Paciente
        SET
            PacienteNombre = @PacienteNombre,
            PacienteApellido = @PacienteApellido,
            PacienteDireccion = @PacienteDireccion,
            PacienteTelefono = @PacienteTelefono,
            PacienteNacimiento = @PacienteNacimiento,
            EECCCodigo = @EECCCodigo,
            GeneroCCodigo = @GeneroCCodigo
        WHERE PacienteCodigo = @PacienteCodigo;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;

CREATE PROCEDURE usp_ListarPacienteDNI
(
    @PacienteCodigo varchar(8)
)
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Paciente
        WHERE PacienteCodigo = @PacienteCodigo;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;


CREATE PROCEDURE usp_ListarPaciente
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Paciente;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;

INSERT INTO [dbo].[Paciente]
      ([PacienteCodigo]
      ,[PacienteNombre]
      ,[PacienteApellido]
      ,[PacienteDireccion]
      ,[PacienteTelefono]
      ,[PacienteNacimiento]
      ,[EECCCodigo]
      ,[GeneroCCodigo])
   VALUES
      ('07654321','PEDRO','PICAPIEDRA',
  'CALLE ROCADURA 123',987654321,
  '2000-01-01',1,2)
GO

select * from paciente

EXEC usp_ListarPaciente


-------------PARA ESPECIALISTA------------------------

CREATE PROCEDURE usp_InsertarEspecialista
(
    @EspecialistaCMP int,
    @EspecialistaNombre varchar(30),
    @EspecialistaApellido varchar(50),
    @EspecialidadCodigo int
)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Especialista (EspecialistaCMP, EspecialistaNombre, EspecialistaApellido, EspecialidadCodigo)
        VALUES (@EspecialistaCMP, @EspecialistaNombre, @EspecialistaApellido, @EspecialidadCodigo);
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;




CREATE PROCEDURE usp_EliminarEspecialista
(
    @EspecialistaCMP int
)
AS
BEGIN
    BEGIN TRY
        DELETE FROM Especialista WHERE EspecialistaCMP = @EspecialistaCMP;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;



CREATE PROCEDURE usp_ActualizarEspecialista
(
    @EspecialistaCMP int,
    @EspecialistaNombre varchar(30),
    @EspecialistaApellido varchar(50),
    @EspecialidadCodigo int
)
AS
BEGIN
    BEGIN TRY
        UPDATE Especialista
        SET EspecialistaNombre = @EspecialistaNombre,
            EspecialistaApellido = @EspecialistaApellido,
            EspecialidadCodigo = @EspecialidadCodigo
        WHERE EspecialistaCMP = @EspecialistaCMP;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;



CREATE PROCEDURE usp_ListarEspecialistas
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Especialista;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;



CREATE PROCEDURE usp_ListarEspecialistaCMP
(
    @EspecialistaCMP int
)
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Especialista WHERE EspecialistaCMP = @EspecialistaCMP;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER(), ERROR_MESSAGE();
    END CATCH
END;


INSERT INTO [dbo].[Especialista]
      ([EspecialistaCMP]
      ,[EspecialistaNombre]
      ,[EspecialistaApellido]
      ,[EspecialidadCodigo])
   VALUES
      (123426789, 'JUAN VIDAL', 'HURTADO', 1);


select * from Especialista

EXEC usp_ListarEspecialistas


