create database db_Escola;
use db_Escola;

create table tb_Cliente(
	clienteId int primary key auto_increment,
    cliNome varchar(150) not null,
    cliEmail varchar(150) not null
);

delimiter $$
create procedure spInsertCliente(vcliNome varchar(150), vcliEmail varchar(150))
begin
if not exists (select clienteId from tb_Cliente where cliNome = vcliNome) then
	insert into tb_Cliente(cliNome, cliEmail) values (vcliNome, vcliEmail);
    else
		select "Já existe";
	end if;
end $$


call spInsertCliente("Carlos", "cc@escola.com");
call spInsertCliente("Davizinho", "zinho@escola.com");
call spInsertCliente("Lindinha", "lindi@escola.com");

select * from tb_Cliente;

create table tb_ClienteHistorico like tb_Cliente;
alter table tb_ClienteHistorico modify clienteId int not null;
alter table tb_ClienteHistorico drop primary key;

alter table tb_ClienteHistorico add Situacao varchar(100);
alter table tb_ClienteHistorico add Momento datetime;

alter table tb_ClienteHistorico
add Constraint PK_Id_ClienteHistorico primary key(clienteId, Situacao, Momento);

describe tb_ClienteHistorico;

Delimiter //
create trigger TRG_CliHistoricoInsert after insert on tb_Cliente
	for each row 
begin 
	insert into tb_ClienteHistorico 
		set clienteId = New.clienteId,
		  cliNome = New.cliNome,
         cliEmail = New.cliEmail,
       Momento = current_timestamp(),
          Situacao = "novo";
end // 

insert into tb_Cliente(cliNome,cliEmail)
	values("Tontinho", "tonti@escola.com");
    
select * from tb_ClienteHistorico;
