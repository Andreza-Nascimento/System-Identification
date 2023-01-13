% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 2º TRABALHO COMPUTACIONAL

%% Parte 1.1

% Modelo ARX(n,m) -- n->saída ; m->entrada

clc; clear all; close all;

m_in = 1;
n_out = 2;
Nu = 500;

u = prbs(m_in,Nu);

y=zeros(1,n);

for k=n_out+1:2*Nu,
  y(k) = 0.43*y(k-1)-0.67*y(k-2) + 1.98*u(k-1) + sqrt(sig2)*randn;
endfor

for k=1:Nu
    y(k) = 0.4*y(k-(n_out-1))-0.6*y(k-(n_out))+2*u(k-m_in);
end