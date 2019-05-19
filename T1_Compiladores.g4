grammar Lua;

@members {
   public static String grupo="<743513, 743529, 743571>";
}

/*ANÁLISE LÉXICA */

PALAVRA_RESERVADA: 'and' | 'break' | 'do' | 'else' | 'elseif' | 'end' | 'false' | 'for' | 'function' | 'if' | 'in' | 'local' | 'nil' | 'not' | 'or' | 'repeat' | 'return' | 'then' | 'true' | 'until' | 'while' ;

OP_ARITMETICO: '+' | '-' | '*' | '/' | '%' | '^' ;

OP_RELACIONAL: '<=' | '>=' | '<' | '>' | '==' | '~=' ;

ATRIBUICAO: '=' ;

ABRE_PARENTESES: '(' ;

FECHA_PARENTESES: ')' ;

NUM_REAL: ('+'|'-')?([0-9])+ ('.' ([0-9])+) ;

VIRGULA: ',' ;

P_VIRGULA: ';' ;

PONTO: '.' ;

CARACTERES: ([a-z] | [A-Z] | '_')+ ([a-z] | [A-Z] | '_' | [0-9])* ;

CADEIA: '\'' ( ~( '\'' | '\\' ) )* '\'' ;

ESPACO_BRANCO: (' ') -> skip ;

FIM_LINHA: ('\n' | '\t') -> skip ;

COMENTARIO: '--' ~('\n' | '\r')+ -> skip ;


/*ANALISE SINTÁTICA*/

programa: codigo;

codigo: declara_funcao | comando;

declara_funcao: 'function' nome_funcao ABRE_PARENTESES (nome_variavel (VIRGULA nome_variavel)*)? FECHA_PARENTESES corpo_funcao;

nome_funcao: CARACTERES ('.' CARACTERES)?;

nome_funcao_tabela: nome_funcao{TabelaDeSimbolos.adicionarSimbolo($nome_funcao.text, Tipo.FUNCAO); };

nome_variavel: CARACTERES{TabelaDeSimbolos.adicionarSimbolo($CARACTERES.text, Tipo.VARIAVEL); };

corpo_funcao: comando 'end' P_VIRGULA;

chama_funcao: nome_funcao ABRE_PARENTESES (lista_parametros)? FECHA_PARENTESES;

lista_parametros: parametros (VIRGULA (parametros))*;

parametros: CARACTERES | NUM_REAL | expressao | CADEIA;

condicao: 'if' comparacao 'then' comando ('else' comando)? 'end';

comparacao: expressao OP_RELACIONAL expressao;

termo: CARACTERES | NUM_REAL | chama_funcao;

expressao: ABRE_PARENTESES expressao FECHA_PARENTESES r | termo r
r: | OP_ARITMETICO termo r;

comando: comando2 retorno?;

comando2: (chama_funcao | condicao | loop | do | repeticao | atribuicao | comando);

atribuicao: ('local')? nome_variavel ATRIBUICAO (parametros | 'true' | 'false');

loop: 'for' atribuicao VIRGULA expressao do 'end' P_VIRGULA;

do: 'do' comando 'end';

repeticao: 'repeat' comando 'until' comparacao P_VIRGULA;

retorno: 'return' expressao;
