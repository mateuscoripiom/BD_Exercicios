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

Delimiter //
create trigger TRG_CliHistoricoAtua after update on tb_Cliente
	for each row 
begin 
	insert into tb_ClienteHistorico 
		set clienteId = New.clienteId,
		  cliNome = New.cliNome,
         cliEmail = New.cliEmail,
       Momento = current_timestamp(),
          Situacao = "Depois";
	insert into tb_ClienteHistorico 
		set clienteId = Old.clienteId,
		  cliNome = Old.cliNome,
         cliEmail = Old.cliEmail,
       Momento = current_timestamp(),
          Situacao = "Antes";
end // 
    
select * from tb_Cliente;
select * from tb_ClienteHistorico;

delimiter $$
create procedure spAtualizarClienteNome(vcliNome varchar(150), vNomeAntigo varchar(150))
begin
	update tb_Cliente
    set cliNome = vcliNome where vNomeAntigo = cliNome; 
end $$

drop procedure spAtualizarClienteNome;

call spAtualizarClienteNome("Muito Tontinho", "Tontinho");
call spAtualizarClienteNome("Lindinha de Morrer", "Lindinha");

delimiter $$
create procedure spAtualizarClienteComID(vclienteID int, vcliNome varchar(150), vcliEmail varchar(150))
begin
	update tb_Cliente
    set cliNome = vcliNome, cliEmail = vcliEmail where clienteId = vclienteID; 
end $$

call spAtualizarClienteNomeID(4, "Muito Tontinho", "tonti@escola.com");
call spAtualizarClienteNomeID(3, "Lindinha de Morrer", "lindi@escola.com");
