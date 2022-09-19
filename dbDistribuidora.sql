-- BOM DIA, INTRUSO. LUAN E MATEUS ADORAM SUA PRESENÇA AQUI

-- JOGANDO FORA O BANCO 
drop database dbDistribuidoraLM;

-- CRIAÇÃO O BANCO
create database dbDistribuidoraLM;

-- USO DO BANCO
use dbDistribuidoraLM;

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
 Id int auto_increment primary key,
 Nome varchar(50) not null,
 CEP decimal(8,0) not null,
 foreign key (CEP) references tbEndereco(CEP),
 NumEnd decimal(6,0) not null,
 CompEnd varchar(50)
);

-- TABELA CLIENTE PF -- PESSOA FÍSICA
create table tbClientePF (
 IdCliente int auto_increment,
 foreign key (IdCliente) references tbCliente(Id),
 Cpf decimal(11,0) not null primary key, -- pode ter futuros erros aqui
 Rg decimal(8,0),
 RgDig char(1),
 Nasc date
);

-- TABELA CLIENTE PJ -- PESSOA JURÍDICA
create table tbClientePJ (
 IdCliente int auto_increment,
 foreign key (IdCliente) references tbCliente(Id),
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
 IdCliente int not null,
 foreign key (IdCliente) references tbCliente(Id),
 NumeroVenda int primary key,
 DataVenda datetime not null default(current_timestamp()),
 TotalVenda decimal(7, 2) not null,
 NotaFiscal int,
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
delimiter $$
create procedure spInsertCliente (vNome varchar(50), vNumEnd decimal(6,0), vCompEnd varchar(50), vCEP decimal(8,0), vCPF decimal(11,0), vRG decimal(8,0), vRgDig char(1), vNasc date,
vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2))
begin
   	if not exists (select CPF from tbClientePF where CPF = vCPF) then
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
    
		insert into tbCliente(Nome, CEP, NumEnd, CompEnd) values (vNome, vCEP, vNumEnd, vCompEnd);
		insert into tbClientePF(CPF, RG, RgDig, Nasc) values (vCPF, vRG, vRgDig, vNasc);
	else
		select "Existe";
	end if;
end $$

-- CALL -- FAZENDO OS INSERTS
call spInsertCliente('Pimpão', 325, null, 12345051, 12345678911, 12345678, 0, '2000-12-10', 'Av. Brasil', 'Lapa', 'Campinas', 'SP');
call spInsertCliente('Disney Chaplin', 89, 'Ap. 12', 12345053, 12345678912, 12345679, 0, '2001-11-21', 'Av. Paulista', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliente('Marciano', 744, null, 12345054, 12345678913, 12345680, 0, '2001-06-01', 'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliente('Lança Perfume', 128, null, 12345059, 12345678914, 12345681, 'X', '2004-04-05', 'Rua Veia', 'Jardim Santa Isabel', 'Cuiabá', 'MT');
call spInsertCliente('Remédio Amargo', 2485, null, 12345058, 12345678915, 12345682, 0, '2002-07-15', 'Av. Nova', 'Jardim Santa Isabel', 'Cuiabá', 'MT');

-- SELECT 
select * from tbClientePF;
select * from tbCliente;
select * from tbEndereco;
select * from tbUF;
select * from tbBairro;
select * from tbCidade;

-- FINALIZAÇÃO

-- EXERCÍCIO 8 -- INSERINDO CLIENTES PJ -- 
delimiter $$
create procedure spInsertCliPJ (vNome varchar(50), vCNPJ decimal(14,0), vIE decimal(11,0), vCEP decimal(8,0), vLogradouro varchar(200), vNumEnd decimal(6,0), vCompEnd varchar(50),
vBairro varchar(200), vCidade varchar(200), vUF char(2))

begin
    if not exists (select Cnpj from tbClientePJ where Cnpj = vCNPJ) then
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
        
			insert into tbCliente(Nome, CEP, NumEnd, CompEnd) value(vNome, vCEP, vNumEnd, vCompEnd);
			insert into tbClientePJ(Cnpj, Ie) value (vCNPJ, vIE);
	else
		select "Existe";
	end if;
end $$

-- CALL -- FAZENDO OS INSERTS

call spInsertCliPJ('Paganada', 12345678912345, 98765432198, 12345051, 'Av. Brasil', 159, null, 'Lapa', 'Campinas', 'SP');
call spInsertCliPJ('Caloteando', 12345678912346, 98765432199, 12345053, 'Av. Paulista', 69, null, 'Penha', 'Rio de Janeiro', 'RJ');
call spInsertCliPJ('Semgrana', 12345678912347, 98765432100, 12345060, 'Rua dos Amores', 189, null, 'Sei Lá', 'Recife', 'PE');
call spInsertCliPJ('Cemreais', 12345678912348, 98765432101, 12345060, 'Rua dos Amores', 5024, 'Sala 23', 'Sei Lá', 'Recife', 'PE');
call spInsertCliPJ('Durango', 12345678912349, 98765432102, 12345060, 'Rua dos Amores', 1254, null, 'Sei Lá', 'Recife', 'PE');

-- SELECT 
select * from tbClientePJ;
select * from tbCliente;
select * from tbEndereco;
select * from tbBairro;
select * from tbUF;
select * from tbCidade;

-- FINALIZAÇÃO

-- EXERCÍCIO 9 -- INSERINDO COMPRAS -- 
delimiter $$
create procedure spInsertCompra(vNotaFiscal int, vFornecedor varchar(200), vDataCompra date, vCodBarras decimal(14,0), vValorItem decimal(6,2),
vQtd int, vQtdTotal int, vValorTotal decimal(8,2))
begin
	if not exists (select NotaFiscal from tbCompra where NotaFiscal = vNotaFiscal) then
		insert into tbCompra(NotaFiscal, DataCompra, ValorTotal, QtdTotal, Cod_Fornecedor) values (vNotaFiscal, vDataCompra, vValorTotal, vQtdTotal,
        (select codigo from tbFornecedor where Nome = vFornecedor));
	end if;
        insert into tbItemCompra(Qtd, ValorItem, NotaFiscal, CodBarras) values (vQtd, vValorItem, vNotaFiscal, vCodBarras);
end $$


-- CALL -- FAZENDO OS INSERTS
call spInsertCompra(8459, 'Amoroso e Doce', '2018-05-01', 12345678910111, 22.22, 200, 700, 21944.00);
call spInsertCompra(2482, 'Revenda Chico Loco', '2020-04-22', 12345678910112, 40.50, 180, 180, 7290.00);
call spInsertCompra(21563, 'Marcelo Dedal', '2020-07-12', 12345678910113, 3.00, 300, 300, 900.00);
call spInsertCompra(8459, 'Amoroso e Doce', '2020-12-04', 12345678910114, 35.00, 500, 700, 21944.00);
call spInsertCompra(156354, 'Revenda Chico Loco', '2021-11-23', 12345678910115, 54.00, 350, 350, 18900.00);

-- SELECT 
select * from tbCompra;
select * from tbFornecedor;
select * from tbItemCompra;

-- FINALIZAÇÃO

-- EXERCÍCIO 10 -- INSERINDO VENDAS -- 
delimiter $$
create procedure spInsertVenda(vNumVenda int, vCliente varchar(200), vDataVenda char(10), vCodBarras decimal(14,0), vValorItem decimal(6,2), vQtd int, vTotalVenda int, vNF int)
begin
	set @IdCli = (select Id from tbCliente where Nome = vCliente);
    set @DataVenda = str_to_date(vDataVenda, "%d/%m/%Y");
    set @CodBarras = (select CodBarras from tbProduto where CodBarras = vCodBarras);

	if not exists (select NumeroVenda from tbVenda where NumeroVenda = vNumVenda) then
		insert into tbVenda(IdCliente, NumeroVenda, DataVenda, TotalVenda, NotaFiscal) values (@IdCli, vNumVenda, @DataVenda, vTotalVenda, vNF);
	end if;
        insert into tbItemVenda(NumeroVenda, CodBarras, Qtd, ValorItem) values (vNumVenda, @CodBarras, vQtd, vValorItem);
end $$


-- CALL -- FAZENDO OS INSERTS
call spInsertVenda(1, 'Pimpão', '22/08/2022', 12345678910111, 54.61, 1, 54.61, null);
call spInsertVenda(2, 'Lança Perfume', '22/08/2022', 12345678910112, 100.45, 2, 200.90, null);
call spInsertVenda(3, 'Pimpão', '22/08/2022', 12345678910113, 44.00, 1, 44.00, null);

-- SELECT 
select * from tbCliente;
select * from tbProduto;
select * from tbVenda;
select * from tbItemVenda;

-- FINALIZAÇÃO

-- EXERCÍCIO 11 -- NOTA FISCAL -- 
delimiter $$
create procedure spInsertNF(vNF int, vCliente varchar(200), vDataEmissao char(10))
begin
	set @IdCli = (select Id from tbCliente where Nome = vCliente);
    set @DataEmissao = str_to_date(vDataEmissao, "%d/%M/%Y");
	set @ValorTotal = (select sum(TotalVenda) from tbVenda where IdCliente = @IdCli);

	if not exists (select NF from tbNotaFiscal where NF = vNF) then
		insert into tbNotaFiscal(NF, TotalNota, DataEmissao) values (vNF, @ValorTotal, @DataEmissao);

   	if not exists (select NotaFiscal from tbVenda where NotaFiscal = vNF) then
		update tbVenda set NotaFiscal = vNF where IdCliente = @IdCli;
	end if;
    else
		select "Existe";
	end if;
end $$

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

select * from tbProduto;

-- EXERCÍCIO 22

call spInsertVenda(4, 'Disney Chaplin', '19/09/2022', 12345678910111, 64.50, 1, 64.50, null);

-- EXERCÍCIO 23

select * from tbVenda order by DataVenda desc limit 1;

-- EXERCÍCIO 24

select * from tbItemVenda order by NumeroVenda desc limit 1;

-- EXERCÍCIO 25

delimiter $$
end $$

-- FINALIZAÇÃO





 

