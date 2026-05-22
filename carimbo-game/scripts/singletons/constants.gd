extends Node

enum OBJETO {TEXTO, VALOR}

enum CENAS_ORDENADAS {
	SALA_RH, FABRICA_DE_BRINQUEDO, CORREDOR_2, CORREDOR_1,
	SUPERVISOR, ESCRITORIO, PONTO_DE_ONIBUS, CASA, RH_ROOM
}

const UID_CENAS = {
	CENAS_ORDENADAS.SALA_RH: "uid://di2frw21hjxmy",
	CENAS_ORDENADAS.FABRICA_DE_BRINQUEDO: "uid://buh14ccpn2kjf",
	CENAS_ORDENADAS.CORREDOR_2: "uid://dx8u2tk73esb1",
	CENAS_ORDENADAS.CORREDOR_1: "uid://bsugtk4ao1xgx",
	CENAS_ORDENADAS.SUPERVISOR: "uid://cchabkie6bchw",
	CENAS_ORDENADAS.ESCRITORIO: "uid://drgsnnyju2haj",
	CENAS_ORDENADAS.PONTO_DE_ONIBUS: "uid://btju0ygewfqvf",
	CENAS_ORDENADAS.CASA: "uid://ckt4hs4bl6f1g",
	CENAS_ORDENADAS.RH_ROOM: "uid://cnvko75fd3ry5",
}

enum TELAS {
	TELA_INICIAL,TELA_PAUSE,TELA_LOADING,
	TELA_CONFIG,TELA_CREDITOS,TELA_BATALHA,
	DESK, TUTORIAL, INTRO_SCENE, WORLD
}

const UID_SCENES = {
	TELAS.TELA_INICIAL: "uid://dfup2bdf5sdnw",
	TELAS.TELA_PAUSE: "uid://bwstta8psu4ph",
	TELAS.TELA_LOADING: "uid://ck8l2lqfa2r4y",
	TELAS.TELA_CONFIG: "uid://ds226ph62jpir",
	TELAS.TELA_CREDITOS: "uid://bok2i3ulpkeq8",
	TELAS.TELA_BATALHA: "uid://clk1ysjnbyd46",
	TELAS.DESK: "uid://54vcmnecmgu8",
	TELAS.TUTORIAL: "uid://i3jev2a6unrr",
	TELAS.INTRO_SCENE: "uid://ji0fgryf6u3f",
	TELAS.WORLD: "uid://crai6bkwh21uc"
}


enum ACOES {PARA_CIMA,PARA_BAIXO,PARA_ESQUERDA,PARA_DIREITA,INTERAGIR}
const ACOES_CUSTOM = {
	ACOES.PARA_ESQUERDA: {OBJETO.VALOR: "para_esquerda", OBJETO.TEXTO: "Mover para esquerda"},
	ACOES.PARA_DIREITA: {OBJETO.VALOR: "para_direita", OBJETO.TEXTO: "Mover para direita"},
	ACOES.INTERAGIR: {OBJETO.VALOR: "interagir", OBJETO.TEXTO: "Interagir"},
}

enum RESOLUCOES {RES_640X320,RES_1280X720,RES_1920X1080,RES_2560X1440}
const RESOLUCAO_DICT = {
	RESOLUCOES.RES_640X320: {OBJETO.VALOR: Vector2i(640, 320), OBJETO.TEXTO: "640x320"},
	RESOLUCOES.RES_1280X720: {OBJETO.VALOR: Vector2i(1280, 720), OBJETO.TEXTO: "1280x720"},
	RESOLUCOES.RES_1920X1080: {OBJETO.VALOR: Vector2i(1920, 1080), OBJETO.TEXTO: "1920x1080"},
	RESOLUCOES.RES_2560X1440: {OBJETO.VALOR: Vector2i(2560, 1440), OBJETO.TEXTO: "2560x1440"},
}

enum MODOS {JANELA,TELA_CHEIA}
const MODO_DICT = {
	MODOS.JANELA: {OBJETO.VALOR: Window.MODE_WINDOWED, OBJETO.TEXTO: "Janela"},
	MODOS.TELA_CHEIA: {OBJETO.VALOR: Window.MODE_EXCLUSIVE_FULLSCREEN, OBJETO.TEXTO: "Tela cheia"},
}

enum OBJETIVOS {
	JULGAR_CARTAS,
	ENCONTRAR_SUPERVISOR,
	VOLTAR_PARA_CASA,
	VOLTAR_TRABALHAR,
	JULGAR_OUTRAS_CARTAS,
	ENTREGAR_CARTAS,
	IR_SALA_SUPERVISOR,
	DERROTAR_ELFO,
	ENCONTRAR_ELFO_SUPERVISOR,
	PASSAR_RH,
	DERROTAR_EL_PAPA
}

var OBJETIVOS_TEXTOS := {
	OBJETIVOS.JULGAR_CARTAS: "JULGUE AS CARTAS ATE O FINAL",
	OBJETIVOS.ENCONTRAR_SUPERVISOR: "ENCONTRE O SUPERVISOR",
	OBJETIVOS.VOLTAR_PARA_CASA: "VOLTE PARA CASA",
	OBJETIVOS.VOLTAR_TRABALHAR: "VOLTE A TRABALHAR",
	OBJETIVOS.JULGAR_OUTRAS_CARTAS: "JULGUE OUTRAS CARTAS",
	OBJETIVOS.ENTREGAR_CARTAS: "ENTREGUE AS CARTAS AO SUPERVISOR",
	OBJETIVOS.IR_SALA_SUPERVISOR: "VÁ ATE A SALA DO SUPERVISOR",
	OBJETIVOS.DERROTAR_ELFO: "DERROTE O ELFO",
	OBJETIVOS.ENCONTRAR_ELFO_SUPERVISOR: "ENCONTRE O ELFO SUPERVISOR NA FÁBRICA",
	OBJETIVOS.PASSAR_RH: "PASSE NO RH",
	OBJETIVOS.DERROTAR_EL_PAPA: "DERROTE O EL PAPA"
}

const DIALOGOS = {
	"INTRO_DIA_1": [
		{"text": "Primeiro dia de trabalho"},
		{"text": "Coisa super fácil, apenas pegar as cartas e carimbar"},
		{"text": "Se a criança merecer o presente, carimbo verde. Caso não, carimbo vermelho"}
	],
	"LIVIA": [
		{"text": "A carta apresenta palavras em uma letra bem ilegível"},
		{"text": "É visível que a criança se empenhou para escrever, mas ainda não sabe como"},
		{"text": "Abaixo do indecifrável, existe um desenho feito de giz de cera"},
		{"text": "Parecia uma casa. Talvez uma casa de bonecas?"}
	],
	"BENJAMIN": [
		{"text": "Essa carta é… diferente."},
		{"text": "Parece conter um código ou um pedido de socorro escondido."},
		{"text": "Eu não deveria carimbar isso sem falar com o Supervisor antes."}
	],
	"THIAGO_FINISH": [
		{"text": "Eu deveria ir tirar satisfação com ele agora"}
	],
	"UNLOCK_STASH": [
		{"text": "Talvez eu devesse guardar essas cartas estranhas?"}
	],
	"SUPERVISOR_01": [
		{"text": "Protagonista: Com licença senhor supervisor"},
		{"text": "em meio às cartas de hoje, encontrei esta."},
		{"text": "achei a carta meio estranha"},
		{"text": "acho que a situação deveria ser levada para as autoridades e investigada."},
		{"text": "*Entrega a carta para o supervisor*"},
		{"text": "Supervisor: Não dá muita bola pra isso não"},
		{"text": "*supervisor guarda a carta no bolso do paletó*"},
		{"text": "Supervisor: Em caso de mais cartas do tipo, me entregue"},
		{"text": "agora volte ao tranbalho"},
	],
	"SUPERVISOR_02": [
		{"text": "Protagonista: Você?! Por que você descartaria essas cartas?!"},
		{"text": "podem ser provas de crimes! No que você está pensando?!"},
		{"text": "Supervisor: Eu não tenho as suas respostas, só sigo ordens de cima"},
		{"text": "e você não deveria fazer tantas perguntas, o contrato do emprego explicita isso."},
		{"text": "Protagonista: eu vou entregar essas cartas para as autoridades com as minhas próprias mãos"},
		{"text": "Supervisor: se eu fosse você, não faria isso. ELE vai ir atrás de tudo com o que você se importa"},
		{"text": "Protagonista: Então irei começar derrotando você!!!!"},
	]
}
