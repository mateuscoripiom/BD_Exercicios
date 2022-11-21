
-- JOGANDO FORA O BANCO 
drop database dbDistribuiaaraLM;

-- CRIAÇÃO O BANCO
create database dbDistribuiaaraLM;

-- USO DO BANCO
use dbDistribuiaaraLM;

-- CRIAÇÃO DAS TABELAS

-- INICIALIZAÇÃO DO GRUPO ENDEREÇO

-- TABELA UF -- TABELA ESTADO
create table tbUF (
 IdUF int auto_increment primary key,
 UF char(2) unique
);

-- TABELA BAIRRO
create table tbBairro (
 IdBairro int auto_increment primary key,
 Bairro varchar(200) -- PODE OU NÃO O NOT NULL?
);

-- TABELA CIDADE
create table tbCidade (
 IdCidade int auto_increment primary key,
 Cidade varchar(200)
);

-- TABELA ENDEREÇO 
create table tbEndereco (
 CEP decimal(8,0) primary key,
 Logradouro varchar(200),
 IdBairro int,
 foreign key (IdBairro) references tbBairro(IdBairro),
 IdCidade int,
 foreign key (IdCidade) references tbCidade(IdCidade),
 IdUF int,
 foreign key (IdUF) references tbUF(IdUF)
);

-- FINALIZAÇÃO DO GRUPO -- COMPONENTES DO ENDEREÇO 

-- INICIALIZAÇÃO DO GRUPO CLIENTE

-- TABELA CLIENTE
create table tbCliente (
 IdCli int auto_increment primary key,
 NomeCli varchar(50) not null,
 CEP decimal(8,0) not null,
 foreign key (CEP) references tbEndereco(CEP),
 NumEnd decimal(6,0) not null,
 CompEnd varchar(50)
);

-- TABELA CLIENTE PF -- PESSOA FÍSICA
create table tbClientePF (
 IdCli int auto_increment,
 foreign key (IdCli) references tbCliente(IdCli),
 Cpf decimal(11,0) not null primary key, -- pode ter futuros erros aqui
 Rg decimal(8,0),
 RgDig char(1),
 Nasc date
);

-- TABELA CLIENTE PJ -- PESSOA JURÍDICA
create table tbClientePJ (
 IdCli int auto_increment,
 foreign key (IdCli) references tbCliente(IdCli),
 Cnpj decimal(14,0) not null primary key,
 Ie decimal(11,0)
);

-- FINALIZAÇÃO DO GRUPO CLIENTE -- COMPONENTES DO CLIENTE

-- INICIALIZAÇÃO DO GRUPO COMPRA

-- TABELA NOTA FISCAL
create table tbNotaFiscal (
 NF int primary key,
 TotalNota decimal(7, 2) not null,
 DataEmissao date not null
);

-- TABELA FORNECEDOR 
create table tbFornecedor (
 Codigo int primary key auto_increment,
 Cnpj decimal(14,0) unique not null,
 Nome varchar(200) not null,
 Telefone decimal(11,0)
);

-- TABELA COMPRA 
create table tbCompra (
 NotaFiscal int primary key,
 DataCompra date not null,
 ValorTotal decimal(8, 2) not null,
 QtdTotal int not null,
 Cod_Fornecedor int,
 foreign key (Cod_Fornecedor) references tbFornecedor(Codigo)
);

-- TABELA PRODUTO 
create table tbProduto (
 CodBarras decimal(14,0) primary key,
 Qtd int,
 Nome varchar(200) not null,
 ValorUnitario decimal(6, 2) not null
);

-- TABELA ITEM COMPRA 
create table tbItemCompra (
 Qtd int not null,
 ValorItem decimal(6, 2) not null,
 NotaFiscal int,
 CodBarras decimal(14,0),
 primary key (Notafiscal, CodBarras),
 foreign key (NotaFiscal) references tbCompra(NotaFiscal),
 foreign key (CodBarras) references tbProduto(CodBarras)
);

-- FINALIZAÇÃO GRUPO COMPRA -- COMPONENTES DA COMPRA

-- INICIALIZAÇÃO GRUPO VENDA

-- TABELA VENDA
create table tbVenda (
 IdCli int not null,
 foreign key (IdCli) references tbCliente(IdCli),
 NumeroVenda int primary key auto_increment,
 DataVenda datetime not null default(current_timestamp()),
 TotalVenda decimal(7, 2) not null,
 NotaFiscal int,
 QtdTotal int not null,
 foreign key (NotaFiscal) references tbNotaFiscal(NF)
);

-- TABELA ITEM VENDA
create table tbItemVenda (
 NumeroVenda int,
 CodBarras decimal(14,0),
 foreign key (NumeroVenda) references tbVenda(NumeroVenda),
 foreign key (CodBarras) references tbProduto(CodBarras),
 Qtd int not null,
 ValorItem decimal(6, 2) not null
);

-- FINALIZAÇÃO DO GRUPO VENDA -- COMPONENTES DA VENDA

-- CRIAÇÃO DAS "PROCEDURES", FAMOSA FUNCTION

-- EXERCÍCIO 1 -- INSERINDO FORNECEDORES -- NÃO PODE REPETIR
delimiter $$
create procedure spInsertFornec(vNome varchar(200), vCNPJ decimal(14,0), vTelefone decimal(11,0))
begin
	if not exists (select CNPJ from tbFornecedor where CNPJ = vCNPJ) then
		insert into tbFornecedor(Nome, CNPJ, Telefone) values (vNome, vCNPJ, vTelefone);
	else
		select 'Já Existe';
	end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertFornec('Revenda Chico Loco', 1245678937123, 11934567897);
call spInsertFornec('José Faz Tudo S/A', 1345678937123, 11934567898);
call spInsertFornec('Vadalto Entregas', 1445678937123, 11934567899);
call spInsertFornec('Astrogildo das Estrela', 1545678937123, 11934567800);
call spInsertFornec('Amoroso e Doce', 1645678937123, 11934567801);
call spInsertFornec('Marcelo Dedal', 1745678937123, 11934567802);
call spInsertFornec('Franciscano Cachaça', 1845678937123, 11934567803);
call spInsertFornec('Joãozinho Chupeta', 1945678937123, 11934567804);

-- SELECT 
select * from tbFornecedor;

-- FINALIZAÇÃO

-- EXERCÍCIO 2 -- INSERINDO CIDADES
delimiter $$
create procedure spInsertCidade(vCidade varchar(200))
begin
if not exists (select IdCidade from tbCidade where Cidade = vCidade) then -- SE NÃO EXISTE O IDCIDADE ENTÃO FAÇA
	insert into tbCidade(Cidade) values (vCidade);
end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertCidade('Rio de Janeiro');
call spInsertCidade('São Carlos');
call spInsertCidade('Campinas');
call spInsertCidade('Franco da Rocha');
call spInsertCidade('Osasco');
call spInsertCidade('Pirituba');
call spInsertCidade('Lapa');
call spInsertCidade('Ponta Grossa');

-- SELECT 
select * from tbCidade;

-- FINALIZAÇÃO

-- EXERCÍCIO 3 -- INSERINDO ESTADOS
delimiter $$
create procedure spInsertUF(vUF char(2))
begin
if not exists (select IdUf from tbUF where UF = vUF) then
	insert into tbUF(UF) values (vUF);
end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertUF('SP');
call spInsertUF('RJ');
call spInsertUF('RS');

-- SELECT 
select * from tbUF;

-- FINALIZAÇÃO

-- EXERCÍCIO 4 -- INSERINDO BAIRROS 
delimiter $$
create procedure spInsertBairro(vBairro varchar(200))
begin
if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
	insert into tbBairro(Bairro) values (vBairro);
end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertBairro('Aclimação');
call spInsertBairro('Capão Redondo');
call spInsertBairro('Pirituba');
call spInsertBairro('Liberdade');

-- SELECT 
select * from tbBairro;

-- FINALIZAÇÃO

-- EXERCÍCIO 5 -- INSERINDO PRODUTOS -- NÃO PODE REPETIR
delimiter $$
create procedure spInsertProduto(vCodBarras decimal(14,0), vNome varchar(200), vValorUnitario decimal(6, 2), vQtd int)
begin
	if not exists (select CodBarras from tbProduto where CodBarras = vCodBarras) then
		insert into tbProduto(CodBarras, Nome, ValorUnitario, Qtd) values (vCodBarras, vNome, vValorUnitario, vQtd); 
	else
		select 'Já Existe';
    end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertProduto('12345678910111', 'Rei de Papel Mache', '54.61', '120');
call spInsertProduto('12345678910112', 'Bolinha de Sabão', '100.45', '120');
call spInsertProduto('12345678910113', 'Carro Bate Bate', '44.00', '120');
call spInsertProduto('12345678910114', 'Bola Furada', '10.00', '120');
call spInsertProduto('12345678910115', 'Maçã Laranja', '99.44', '120');
call spInsertProduto('12345678910116', 'Boneco do Hitler', '124.00', '200');
call spInsertProduto('12345678910117', 'Farinha de Suruí', '50.00', '200');
call spInsertProduto('12345678910118', 'Zelador de Cemitério', '24.50', '100');

-- SELECT 
select * from tbProduto;

-- FINALIZAÇÃO

-- EXERCÍCIO 6 -- INSERINDO ENDEREÇOS
delimiter $$
create procedure spInsertEndereco(vCEP decimal(8,0), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
if not exists (select CEP from tbEndereco where CEP = vCEP) then
	if not exists (select IdBairro from tbBairro where Bairro = vBairro) then
		insert into tbBairro(Bairro) values (vBairro);
	end if;

	if not exists (select IdUf from tbUF where UF = vUF) then
		insert into tbUF(UF) values (vUF);
	end if;

	if not exists (select IdCidade from tbCidade where Cidade = vCidade) then
		insert into tbCidade(Cidade) values (vCidade);
	end if;

	set @IdBairro = (select IdBairro from tbBairro where Bairro = vBairro);
	set @IdUf = (select IdUF from tbUF where UF = vUf);
	set @IdCidade = (select IdCidade from tbCidade where Cidade = vCidade);

	insert into tbEndereco(CEP, Logradouro, IdBairro, IdCidade, IdUF) values
	(vCEP, vLogradouro, @IdBairro, @IdCidade, @IdUF); 
end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertEndereco(12345050, 'Rua da Federal', 'Lapa', 'São Paulo', 'SP');
call spInsertEndereco(12345051, 'Av Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertEndereco(12345052, 'Rua Liberdade', 'Consolação', 'São Paulo', 'SP');
call spInsertEndereco(12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertEndereco(12345054, 'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertEndereco(12345055, 'Rua Piu XI', 'Penha', 'Campina', 'SP');
call spInsertEndereco(12345056, 'Rua Chocolate', 'Aclimação', 'Barra Mansa', 'RJ');
call spInsertEndereco(12345057, 'Rua Pão na Chapa', 'Barra Funda', 'Ponto Grossa', 'RS');

-- SELECT 
select * from tbBairro;
select * from tbEndereco;
select * from tbUF;
select * from tbCidade;

-- FINALIZAÇÃO

-- EXERCÍCIO 7 -- INSERINDO CLIENTES -- NÃO PODE REPETIR

select * from tbClientePF;
select * from tbCliente;
select * from tbEndereco;
select * from tbUF;
select * from tbBairro;
select * from tbCidade;

delimiter $$
 create procedure spInsertClientePf(vNomeCli varchar(200), vNumEnd decimal(6,0), vCompEnd varchar(50), vCepCli decimal(8,0), vCpf decimal(11,0), vRg decimal(9,0), vRg_Dig char(1), vNasc date,vLogradouro varchar(200),vBairro varchar(200), vCidade varchar(200), vEstado varchar(200))
 begin
	if not exists(select * from tbEndereco where CEP = vCepCli) then
		call spInsertEndereco(vCepCli,vLogradouro,vBairro,vCidade, vEstado);
	end if;
		if not exists(select * from tbClientePf where CPF = vCPF) then
			insert into tbCliente(NomeCli,NumEnd,CompEnd,cep) values (vNomeCli,vNumEnd,vCompEnd,vCepCli);
			set @idCli = (select max(IdCli) from tbCliente);
			insert into tbClientePf(CPF, RG, RGDig, Nasc, IdCli) values (vCPF, vRG, vRG_Dig, vNasc, @IdCli);
		else
		select "Existe";
    end if;
 end
 $$

call spInsertClientePf("Pimpão",325,null,12345051,12345678911,12345678,"0","2000-10-12","Av. Brasil","Lapa","Campinas","SP");
call spInsertClientePf("Disney Chaplin",89,"Ap. 12",12345053,12345678912,12345679,"0","2000-11-21","Av. Brasil","Penha","Rio de Janeiro","RJ");
call spInsertClientePf("Marciano",744,null,12345054,12345678913,12345680,"0","2000-06-01","Rua Ximbu","Penha","Rio de Janeiro","RJ");
call spInsertClientePf("Lança Perfume",128,null,12345059,12345678914,12345681,"X","2000-04-05","Rua veia","Jardim Santa Isabel","Cuiabá","MT");
call spInsertClientePf("Remédio Amargo",2585,null,12345058,12345678915,12345682,"0","2000-07-15","Av Nova","Jardim Santa Isabel","Cuiabá","MT");



-- EXERCÍCIO 8
delimiter $$
 create procedure spInsertCliPJ(vNomeCli varchar(200),vCNPJ decimal(14,0),vIE decimal(11,0), vCepCli decimal(8,0), vLogradouro varchar(200), vNumEnd decimal(6,0), vCompEnd varchar(50),vBairro varchar(200), vCidade varchar(200), vEstado varchar(200)) 
 begin
	if not exists(select * from tbEndereco where CEP = vCepCli) then
		call spInsertEndereco(vCepCli,vLogradouro,vBairro,vCidade, vEstado);
	end if;
		if not exists(select * from tbClientePJ where CNPJ = vCNPJ) then
			insert into tbCliente(NomeCli,NumEnd,CompEnd,cep) values (vNomeCli,vNumEnd,vCompEnd,vCepCli);
			set @idCli = (select max(IdCli) from tbCliente);
			insert into tbClientePJ(CNPJ, IE, idCli) values (vCNPJ, vIE,@IdCli);
		else
		select "Existe";
		end if;
 end
 $$

call spInsertCliPJ("Paganada",12345678912345,98765432198,12345051,"Av. Brasil",159,null,"Lapa","Campinas","SP");
call spInsertCliPJ("Caloteando",12345678912346,98765432199,12345053,"Av. Paulista",69,null,"Penha","Rio de Janeiro","RJ");
call spInsertCliPJ("Semgrana",12345678912347,98765432100,12345060,"Rua dos Amores",189,null,"Sei lá","Recife","PE");
call spInsertCliPJ("Cemreais",12345678912348,98765432101,12345060,"Rua dos Amores",5024,"Sala 23","Sei lá","Recife","PE");
call spInsertCliPJ("Durango",12345678912349,98765432102,12345060,"Rua dos Amores",1254,null,"Sei lá","Recife","PE");


-- SELECT 
select * from tbClientePJ;
select * from tbCliente;
select * from tbEndereco;
select * from tbBairro;
select * from tbUF;
select * from tbCidade;

-- FINALIZAÇÃO

select * from tbCompra;
select * from tbFornecedor;
select * from tbItemCompra;

-- EXERCÍCIO 9

delimiter $$
create procedure spInsertCompra(vNotaFiscal int,vFornecedor varchar(100), vDataCompra char(10), vCodigoBarras decimal(14,0), vValorItem decimal(5,2), vQtd int,vQtdTotal int,vValorTotal decimal(10,2))
begin
	declare vDataFormatada date;
	if not exists(select * from tbCompra where NotaFiscal = vNotaFiscal) then
        set @Fornecedor = (select Codigo from tbFornecedor where Nome = vFornecedor);
        set vDataFormatada = str_to_date(vDataCompra, '%d/%m/%Y');
		insert into tbCompra(NotaFiscal,DataCompra,ValorTotal,QtdTotal,cod_Fornecedor) values (vNotaFiscal,vDataFormatada,vValorTotal,vQtdTotal,@Fornecedor);
    end if;
    if not exists(select * from tbItemCompra where NotaFiscal = vNotaFiscal and CodBarras = vCodigoBarras) then
    insert into tbItemCompra(NotaFiscal,CodBarras,Qtd,ValorItem) values (vNotaFiscal,vCodigoBarras,vQtd,vValorItem);
 
	end if;
end
$$

call spInsertCompra(8459,"Amoroso e Doce",'01/05/2018',12345678910111,22.22,200,700, 21944.00);
call spInsertCompra(2482,"Revenda Chico Loco",'22/04/2020',12345678910112,40.50,180,180,7290.00);
call spInsertCompra(21653,"Marcelo Dedal",'12/07/2020',12345678910113,3.00,300,300,900.00);
call spInsertCompra(8459,"Amoroso e Doce",'04/12/2020',12345678910114,35.00,500,700,21944.00);
call spInsertCompra(156354,"Revenda Chico Loco",'23/11/2021',12345678910115,54.00,350,350,18900.00);


-- EXERCÍCIO 10 -- INSERINDO VENDAS -- 
delimiter $$
create procedure spInsertVenda(vCliente varchar(200), vCodBarras decimal(14,0), vQtd int, vNF int)
begin
	set @vData = current_timestamp();
    set @vTotal = (select ValorUnitario from tbProduto where CodBarras = vCodBarras);
	if exists (select * from tbProduto, tbCliente where CodBarras = vCodBarras and NomeCli = vCliente) then
		set @idCliente = (select IdCli from tbCliente where NomeCli = vCliente);
		set @codigoVenda = (select NumeroVenda from tbVenda where IdCli = @idCliente);
		if (@codigoVenda is null) then
			insert into tbVenda(IdCli,DataVenda,TotalVenda,QtdTotal,NotaFiscal) values (@idCliente,@vData,0,0,vNF);
		end if;
        set @codigoVenda = (select NumeroVenda from tbVenda where IdCli = @idCliente);
		if not exists(select * from tbItemVenda where NumeroVenda = @codigoVenda and CodBarras = vCodBarras) then
			  insert into tbItemVenda(NumeroVenda,CodBarras,ValorItem,Qtd) values (@codigoVenda,vCodBarras,@vTotal,vQtd);
        else
			select "Venda já realizada";
		end if;
    end if;
	if not exists(select * from tbCliente where NomeCli = vCliente) then 
		select "Cliente inexistente"; 
    end if;
	if not exists(select * from tbProduto where CodBarras = vCodBarras) then 
		select "Produto inexistente";
    end if;
end $$
-- drop procedure spInsertVenda;

delimiter //
create trigger TGR_AtuaVenda after insert on tbItemVenda
for each row
begin
	update tbVenda set TotalVenda = TotalVenda + (new.ValorItem*new.Qtd), QtdTotal = QtdTotal + new.Qtd where NumeroVenda = new.NumeroVenda;
end
//

-- CALL -- FAZENDO OS INSERTS
call spInsertVenda("Pimpão",12345678910111,1,null);
call spInsertVenda("Lança Perfume",12345678910112,2,null);
call spInsertVenda("Pimpão",12345678910113,1,null);

-- SELECT 
select * from tbCliente;
select * from tbEndereco;
select * from tbBairro;
select * from tbProduto;
select * from tbVenda;
select * from tbItemVenda;

-- FINALIZAÇÃO

-- EXERCÍCIO 11 -- NOTA FISCAL -- 
delimiter $$
create procedure spInsertNF(vNF int, vCliente varchar(200), vDataEmissao char(10))
begin
	set @IdCli = (select IdCli from tbCliente where NomeCli = vCliente);
    set @DataEmissao = str_to_date(vDataEmissao, '%d/%m/%Y');
	set @ValorTotal = (select sum(TotalVenda) from tbVenda where IdCli = @IdCli);

	if not exists (select NF from tbNotaFiscal where NF = vNF) then
		insert into tbNotaFiscal(NF, TotalNota, DataEmissao) values (vNF, @ValorTotal, @DataEmissao);

   	if not exists (select NotaFiscal from tbVenda where NotaFiscal = vNF) then
		update tbVenda set NotaFiscal = vNF where IdCli = @IdCli;
	end if;
    else
		select "Existe";
	end if;
end $$
-- drop procedure spInsertNF;

-- CALL -- FAZENDO OS INSERTS
call spInsertNF(359, 'Pimpão', '29/08/2022');
call spInsertNF(360, 'Lança Perfume', '29/08/2022');


-- SELECT 
select * from tbNotaFiscal;
select * from tbCliente;
select * from tbProduto;
select * from tbVenda;

-- DESCRIBE
describe tbNotaFiscal; -- TOTALNOTA CANNOT BE NULL 

-- EXERCÍCIO 12
delimiter $$
create procedure spInsertProduto2(vCodBarras decimal(14,0), vNome varchar(200), vValorUnitario decimal(6, 2), vQtd int)
begin
	if not exists (select CodBarras from tbProduto where CodBarras = vCodBarras) then
		insert into tbProduto(CodBarras, Nome, ValorUnitario, Qtd) values (vCodBarras, vNome, vValorUnitario, vQtd);
	else
		select "Produto já cadastrado";
	end if;
end $$

call spInsertProduto2(12345678910130, "Camiseta de Poliester", 35.61, 100);
call spInsertProduto2(12345678910131, "Blusa Frio Moletom", 200.00, 100);
call spInsertProduto2(12345678910132, "Vestido Decote Redondo", 144.00, 50);

select * from tbProduto;

-- EXERCÍCIO 13
delimiter $$
create procedure spDeleteProduto(vCodBarras decimal(14,0), vNome varchar(200), vValorUnitario decimal(6, 2), vQtd int)
begin
	if (select CodBarras from tbProduto where CodBarras = vCodBarras) then
		delete from tbProduto where (vCodBarras = CodBarras);
	else
		select "Produto não existe";
	end if;
end $$


call spDeleteProduto(12345678910116, "Boneco do Hitler", 124.00, 200);
call spDeleteProduto(12345678910117, "Farinha de Suruí", 124.00, 200);

-- EXERCÍCIO 14
delimiter $$
create procedure spAtualizaProduto(vCodBarras decimal(14,0), vNome varchar(200), vValorUnitario decimal(6, 2))
begin
	if (select CodBarras from tbProduto where CodBarras = vCodBarras) then
		update tbProduto
    set Nome = vNome, ValorUnitario = vValorUnitario where codBarras = vCodBarras; 
	else
		select "Produto não existe";
	end if;
end $$

call spAtualizaProduto(12345678910111, 'Rei de Papel Mache', 64.50);
call spAtualizaProduto(12345678910112, 'Bolinha de Sabão', 120.00);
call spAtualizaProduto(12345678910113, 'Carro Bate Bate', 64.00);

select * from tbProduto;

-- EXERCÍCIO 15
delimiter $$
create procedure spMostrarProduto()
begin
	select * from tbProduto;
end $$

call spMostrarProduto;

-- EXERCÍCIO 16
create table tbProdutoHistorico like tbProduto;

-- EXERCÍCIO 17
alter table tbProdutoHistorico add Ocorrencia varchar(20);
alter table tbProdutoHistorico add Atualizacao datetime;

describe tbProdutoHistorico;

-- EXERCÍCIO 18 
alter table tbProdutoHistorico drop primary key;
alter table tbProdutoHistorico
add Constraint PK_Id_ProdutoHistorico primary key(CodBarras, Ocorrencia, Atualizacao);

-- EXERCÍCIO 19
Delimiter //
create trigger TRG_ProdutoInsert after insert on tbProduto
	for each row 
begin 
	insert into tbProdutoHistorico 
		set CodBarras = New.CodBarras,
				 Nome = New.Nome,
		ValorUnitario = New.ValorUnitario,
			      Qtd = New.Qtd,
           Ocorrencia = "Novo",
          Atualizacao = current_timestamp();
end // 

call spInsertProduto(12345678910119, 'Água mineral', 1.99, 500);

select * from tbProdutoHistorico;

-- EXERCÍCIO 20
Delimiter //
create trigger TRG_ProdutoAtua after update on tbProduto
	for each row 
begin 
	insert into tbProdutoHistorico 
		set CodBarras = New.CodBarras,
				 Nome = New.Nome,
		ValorUnitario = New.ValorUnitario,
			      Qtd = New.Qtd,
           Ocorrencia = "Atualizado",
          Atualizacao = current_timestamp();
end // 

call spAtualizaProduto(12345678910119, 'Água mineral', 2.99);


select * from tbProdutoHistorico;

-- EXERCÍCIO 21

call spMostrarProduto;

-- EXERCÍCIO 22

call spInsertVenda("Disney Chaplin",12345678910111,1, null);
select * from tbVenda;
select * from tbCliente;

-- EXERCÍCIO 23

select * from tbVenda order by DataVenda desc limit 1;

-- EXERCÍCIO 24

select * from tbItemVenda order by NumeroVenda desc limit 1;

-- EXERCÍCIO 25

delimiter $$
create procedure spMostrarCliente (vNomeCli varchar(50))
begin
	select * from tbCliente where NomeCli = vNomeCli;
end $$

call spMostrarCliente("Disney Chaplin");


-- EXERCÍCIO 26
select * from tbProduto;
delimiter //
Create trigger TRG_QtdProd after insert on tbItemVenda
for each row
begin
	update tbProduto set Qtd = Qtd - new.Qtd where CodBarras = new.CodBarras;
end
//
show create procedure spInsertVenda;
-- drop trigger TRG_QtdProd;
    
-- EXERCÍCIO 27
select * from tbProduto;
select * from tbVenda;
select * from tbItemVenda;

call spInsertVenda("Paganada",12345678910114,15, null);

-- EXERCÍCIO 28
call spMostrarProduto;

-- EXERCÍCIO 29
select * from tbCompra;
select * from tbItemCompra;

delimiter //
Create trigger TRG_QtdCompra after insert on tbItemCompra
for each row
begin
	update tbProduto set Qtd = Qtd + new.Qtd where CodBarras = new.CodBarras;
end
//

-- EXERCÍCIO 30
call spInsertCompra(10548, 'Amoroso e Doce', '10/09/2022', 12345678910111, 40.00, 100, 100, 4000.00); 

-- EXERCÍCIO 31
call spMostrarProduto;

-- FINALIZAÇÃO

show tables;

select * from tbcliente;
select * from tbclientepf;
select * from tbendereco;
select * from tbbairro;
select * from tbcidade;
select * from tbuf;

-- EXERCÍCIO 32
select * from tbcliente inner join tbclientepf on tbcliente.IdCli = tbclientepf.IdCli;

-- EXERCÍCIO 33
select * from tbcliente inner join tbclientepj on tbcliente.IdCli = tbclientepj.IdCli;

-- EXERCÍCIO 34
select tbclientepj.IdCli, Nomecli, cnpj, ie,  tbcliente.IdCli from tbcliente inner join tbclientepj on tbcliente.IdCli = tbclientepj.IdCli;

-- EXERCÍCIO 35
select tbclientepf.IdCli as 'Código', Nomecli as 'Nome', cpf  as 'CPF', rg as 'RG', nasc as 'Data Nascimento' from tbcliente inner join tbclientepf on tbcliente.IdCli = tbclientepf.IdCli;

-- EXERCÍCIO 36
select * from tbcliente inner join tbClientepj on tbcliente.IdCli = tbClientepj.IdCli inner join tbendereco on tbcliente.cep = tbendereco.CEP;

-- EXERCÍCIO 37
 select  
     tbcliente.idcli, 
     tbcliente.nomecli, 
     tbcliente.numend, 
     tbcliente.compend, 
     tbcliente.cep, 
     tbbairro.bairro, 
     tbcidade.cidade, 
     tbuf.uf 
 from 
     tbcliente 
         inner join 
     tbclientepj on tbcliente.idcli = tbclientepj.idcli 
         inner join 
     tbendereco on tbendereco.cep = tbcliente.cep 
         inner join 
     tbbairro on tbbairro.idbairro = tbendereco.idbairro 
         inner join 
     tbcidade on tbcidade.idcidade = tbendereco.idcidade 
         inner join 
     tbuf on tbuf.iduf = tbendereco.iduf; 
  
-- EXERCÍCIO 38
delimiter $$ 
create procedure spSelectClientePFID(vIdCli int) 
begin 
     if exists (select * from tbClientePF where Idcli = vIdCli) then 
     select 
		tbcliente.idcli as "Código", 
		tbcliente.nomecli as "Nome", 
		tbclientepf.cpf as "CPF", 
		tbclientepf.rg as "RG", 
		tbclientepf.rgdig as "Digito", 
		tbclientepf.nasc as "Data de Nascimento", 
		tbcliente.cep as "CEP", 
		tbendereco.logradouro as "Logradouro", 
		tbcliente.numend as "Número", 
		tbcliente.compend as "Complemento", 
		tbbairro.bairro "Bairro", 
		tbcidade.cidade "Cidade", 
		tbuf.uf "UF" 
	from 
		tbcliente 
			inner join 
		tbclientepf on tbcliente.idcli = vIdCli 
			inner join 
		tbendereco on tbendereco.cep = tbcliente.cep 
			inner join 
		tbbairro on tbbairro.idbairro = tbendereco.idbairro 
			inner join 
		tbcidade on tbcidade.idcidade = tbendereco.idcidade 
			inner join 
		tbuf on tbuf.iduf = tbendereco.iduf limit 1;
	else  
		select "Cliente não cadastrado"; 
	end if; 
 end; 
 $$ 

call spSelectClientePFID(2);   
call spSelectClientePFID(5);
call spSelectClientePFID(7); 
  
-- EXERCÍCIO 39
select * from tbproduto;
select * from tbitemvenda;

select 
   tbproduto.codbarras, 
   tbproduto.nome, 
   tbproduto.valorunitario, 
   tbproduto.qtd, 
   tbitemvenda.qtd, 
   tbitemvenda.valoritem, 
   tbitemvenda.codbarras,
   tbitemvenda.numerovenda 
from  
   tbproduto  
		left join  
   tbitemvenda on tbproduto.codbarras = tbitemvenda.codbarras; 
          
-- EXERCÍCIO 40
select * from tbcompra;
select * from tbfornecedor;
select  
   tbcompra.notafiscal, 
   tbcompra.datacompra, 
   tbcompra.valortotal, 
   tbcompra.qtdtotal, 
   tbcompra.cod_fornecedor, 
   tbfornecedor.codigo as "Código", 
   tbfornecedor.cnpj, 
   tbfornecedor.nome as "Nome", 
   tbfornecedor.telefone as "Telefone" 
from 
	tbcompra 
		right join 
	tbfornecedor on tbfornecedor.codigo = tbcompra.cod_fornecedor; 
            
-- EXERCÍCIO 41
select 
    tbfornecedor.codigo as "Código",  
    cnpj as "CNPJ",  
    nome as "Nome",  
    telefone as "Telefone"  
from 
	tbcompra 
		right join 
    tbfornecedor on tbcompra.cod_fornecedor = tbfornecedor.codigo where tbcompra.cod_fornecedor is null; 
    
-- EXERCÍCIO 42
select * from tbCLiente;
select * from tbvenda;
select * from tbitemvenda;
select * from tbproduto;
select * from tbnotafiscal;

select  
     tbcliente.idcli, nomecli, datavenda, 
     tbproduto.codbarras, 
     tbproduto.nome, 
     tbitemvenda.valoritem
 from 
     tbcliente 
         inner join 
     tbvenda on tbcliente.idcli = tbvenda.idcli 
         inner join 
     tbitemvenda on tbvenda.numerovenda = tbitemvenda.numerovenda 
         inner join 
     tbproduto on tbitemvenda.codbarras = tbproduto.codbarras 
 where 
     tbvenda.idcli is not null order by nomecli;
     
-- EXERCÍCIO 43
select * from tbbairro;
select * from tbvenda;
select * from tbcliente;
select * from tbendereco;

select distinct bairro 
from 
	tbcliente 
		right join tbvenda
        on tbcliente.id = tbvenda.id_cli
        left join tbitemvenda
        on tbvenda.numerovenda = tbitemvenda.numerovenda
        left join tbendereco
        on tbcliente.cep = tbendereco.cep
        right join tbbairro
        on tbbairro.bairroid = tbendereco.bairro
        where tbitemvenda.codbarras is null and tbitemvenda.numerovenda is null
        
        
-- EXPLICAÇÃO 07/11

/* left join - une os registros da tabela A com a tabela B mantendo TODOS os dados da tabela da esquerda e apenas os dados correspondentes (que se relacionam) da tabela da direita */
/* right join - inverso do left join */
/* cross join (plano cartesiano) - une todos os registros da tabela a com a b */
/* handle for (action continua ou para) - tipo o try catch; tratamento de excessões (forma de visualização de um erro, tratamento de excessões) */
/* union - literalmente UNE	os dados da tabela A com a B. Coloca um acima do outro porém precisa ter a mesma quantidade de colunas, se tiver uma a mais já vai dar um erro */
/* view - é a saída de como o usuário verá, como o select. visualização para o usuário */

select * from tbfornecedor;

-- EXERCÍCIO 44
Create view ViewFornecedor as select codigo, nome, telefone from tbfornecedor;

-- EXERCÍCIO 45
select nome,telefone from ViewFornecedor;

-- EXERCÍCIO 46
select * from tbclientepf;
select * from tbcliente;
select * from tbendereco;

create view ViewClientePJ as 
		select  
			tbcliente.idcli, 
			tbcliente.nomecli, 
			tbcliente.cep, 
            tbendereco.logradouro, 
            tbcliente.numend, 
			tbcliente.compend, 
			tbbairro.bairro, 
			tbcidade.cidade, 
			tbUF.uf  
		from 
			tbcliente 
				inner join 
			tbClientePJ on tbcliente.idcli = tbClientePJ.IdCli 
				inner join 
			tbendereco on tbendereco.cep = tbcliente.cep 
				inner join 
			tbbairro on tbbairro.idbairro = tbendereco.idbairro 
				inner join 
			tbcidade on tbcidade.idcidade = tbendereco.idcidade 
				inner join 
			tbUF on tbUF.iduf = tbendereco.iduf ; 

select * from ViewClientePJ;

-- EXERCÍCIO 47
select idcli as "Código",nomecli as "Cliente", cep as "CEP",logradouro as "Endereço",numend as "Número",compend as "Complemento",bairro as "Bairro",cidade as "Cidade",uf as "UF" from ViewClientePJ;

-- EXERCÍCIO 48
select * from tbclientepf;

create view ViewClientePF as 
		select  
			tbcliente.idcli, 
			tbcliente.nomecli, 
            tbclientepf.cpf,
            tbclientepf.rg,
            tbclientepf.rgdig,
            tbclientepf.nasc,
			tbcliente.cep, 
            tbendereco.logradouro, 
            tbcliente.numend, 
			tbcliente.compend, 
			tbbairro.bairro, 
			tbcidade.cidade, 
			tbUF.uf  
		from 
			tbcliente 
				inner join 
			tbClientePF on tbcliente.idcli = tbClientePF.IdCli 
				inner join 
			tbendereco on tbendereco.cep = tbcliente.cep 
				inner join 
			tbbairro on tbbairro.idbairro = tbendereco.idbairro 
				inner join 
			tbcidade on tbcidade.idcidade = tbendereco.idcidade 
				inner join 
			tbUF on tbUF.iduf = tbendereco.iduf; 

-- EXERCÍCIO 49
select idcli as "Código",nomecli as "Cliente",cpf as "CPF",rg as "RG", rgdig as "Dig", nasc as "Nascimento" from ViewClientePF;
            
