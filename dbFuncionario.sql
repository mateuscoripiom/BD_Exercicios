drop database DB0509LM;
create database DB0509LM;
use DB0509LM;

create table tbFuncionario(
	FuncId int primary key auto_increment,
    FuncNome varchar (150) not null,
    FuncEmail varchar(150) not null
);

insert into tbFuncionario(FuncNome, FuncEmail)
	values('José Mario', 'jose@escola.com'),
		  ('Antonio Pedro', 'ant@escola.com'),
          ('Monica Cascão', 'moc@escola.com');

/* delimiter $$
create procedure spInsertFuncionario(vFuncNome varchar(100), FuncEmail varchar(256))
begin
if not exists (select FuncId from tbFuncionario where FuncNome = vFuncNome) then
	insert into tbFuncionario(FuncNome, FuncEmail) values (vFuncNome, FuncEmail);
    else
		select "Já existe";
	end if;
end $$ */

-- drop procedure spInsertFuncionario;

call spInsertFuncionario('José Mario', 'jose@escola.com');
call spInsertFuncionario('Antonio Pedro', 'ant@escola.com');
call spInsertFuncionario('Monica Cascão', 'moc@escola.com');

-- log transacional

select * from tbFuncionario;

create table tbFuncionarioHistorico like tbFuncionario;

describe tbFuncionarioHistorico;

alter table tbFuncionarioHistorico modify FuncId int not null;
alter table tbFuncionarioHistorico drop primary key;

alter table tbFuncionarioHistorico add Atualizacao datetime;
alter table tbFuncionarioHistorico add Situacao varchar(20);

alter table tbFuncionarioHistorico
add Constraint PK_Id_FuncionarioHistorico primary key(FuncId, Atualizacao, Situacao);

describe tbFuncionarioHistorico;

Delimiter //
create trigger TRG_FuncHistoricoInsert after insert on tbFuncionario
	for each row 
begin 
	insert into tbFuncionarioHistorico 
		set FuncId = New.FuncId,
		  FuncNome = New.FuncNome,
         FuncEmail = New.FuncEmail,
       Atualizacao = current_timestamp(),
          Situacao = "novo";
end // 

insert into tbFuncionario(FuncNome,FuncEmail)
	values("Will JR.", "willj@escola.com");
    
select * from tbFuncionario;
select * from tbFuncionarioHistorico;

Delimiter //
create trigger TRG_FuncHistoricoDelete before delete on tbFuncionario
	for each row 
begin 
	insert into tbFuncionarioHistorico 
		set FuncId = Old.FuncId,
		  FuncNome = Old.FuncNome,
         FuncEmail = Old.FuncEmail,
       Atualizacao = current_timestamp(),
          Situacao = "excluído";
end // 

delete from tbFuncionario where FuncId = 3;
select * from tbFuncionario;
select * from tbFuncionarioHistorico;

Delimiter //
create trigger TRG_FuncHistoricoAtua after update on tbFuncionario
	for each row 
begin 
	insert into tbFuncionarioHistorico 
		set FuncId = New.FuncId,
          FuncNome = New.FuncNome,
         FuncEmail = New.FuncEmail,
       Atualizacao = current_timestamp(),
          Situacao = "Depois";
	insert into tbFuncionarioHistorico 
		set FuncId = Old.FuncId,
          FuncNome = Old.FuncNome,
         FuncEmail = Old.FuncEmail,
       Atualizacao = current_timestamp(),
          Situacao = "Antes";
end // 

drop trigger TRG_FuncHistoricoAtua;

alter table tbFuncionario modify column FuncNome = "Augusto";
ALTER TABLE tbFuncionario RENAME COLUMN id TO employ_id;

UPDATE tbFuncionario
SET 
    FuncNome = "Augusto"
WHERE
    FuncNome = "José Mario";

select * from tbFuncionarioHistorico;
    
set sql_safe_updates = 0;