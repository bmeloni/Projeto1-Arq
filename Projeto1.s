
#---------------------------------------------  ---------------------------------------------
.data

quantidade_times:   .byte 10
tamanho_nome:		  .byte 20

# Textos do Menu Principal
bem_vindo:          .asciiz "\nBem-vindo ao LOL"
titulo:			    .asciiz "Sistema para inscrição e controle de tabela de jogos"
opcao1: 			.asciiz "\n1.Registrar um time;\n"
opcao2:			    .asciiz "2.Registrar resultado;\n"
opcao3:			    .asciiz	"3.Editar as informações dos times;"
opcao4:			    .asciiz	"4.Gerar o resultado do campeonato na fase eliminatória."
opcao5: 			.asciiz "5.Sair\n"
entrada:			.asciiz "\nQual das opcoes voce deseja realizar? "
nao_encontrado: 	.asciiz "Opcao nao encontrada. Informe uma opcao valida"

# Textos do Menu de Edição
opcao_editar_1:     .asciiz "1. Alterar o nome de um time;"
opcao_editar_2:     .asciiz "2. Alterar jogos;"
opcao_editar_3:     .asciiz "3. Alterar a vitória de um time;"
opcao_editar_4:     .asciiz "4. Alterar a derrota de um time;"

# Textos para senha
informe_senha:	    .asciiz "\nDigite a senha de 6 digitos: "
senha_incorreta:	.asciiz "\nSenha incorreta"

# Textos para perguntar qual o time vencedor e qual o time perdedor
perguntar_time_vencedor:	.asciiz "\nDigite o numero de qual time ganhou?"
perguntar_time_perdedor:	.asciiz "\nDigite o numero de qual time perdeu?"

.text
.globl autenticar

  autenticar:
    la $a0, bem_vindo           # Imprime o "\nBem-vindo ao LOL"
    li $v0, 4
    syscall
  
    la $a0, informe_senha
    syscall

    li $t1, 121199
    li $v0, 5
    syscall

    beq $v0, $t1, inicio
    la $a0, senha_incorreta
    li $v0, 4
    syscall

    j autenticar

  inicio:
    jal exibir_menu
    
    li $v0, 5
    syscall

    li $t0, 1
    li $t1, 2
    li $t2, 3
    li $t3, 4
    li $t5, 5

    beq $v0, $t1, registar_times
    beq $v0, $t2, registrar_resultado
    beq $v0, $t3, editar_informacoes
    beq $v0, $t4, exibir_resultados
    beq $v0, $t5, sair_sistema

    la $a0, nao_encontrado
    li $v0, 4
    syscall
    
    j inicio

  registrar_times:
    jal funcao_registrar_times
    j inicio

  registrar_resultado:
    jal funcao_registrar_resultado
    j inicio

  editar_informacoes:
    jal funcao_editar_informacoes
    j inicio

  exibir_resultados:
    jal funcao_exibir_resultados
    j inicio

  sair:
    li $v0, 10
    syscall

  exibir_menu:
    li $v0, 4           # Códogo para exibição de texto 

	  la $a0, titulo    # Impressão do menu
	  syscall

    la $a0, opcao1      # Impressao	da frase "Registrar um time"
    syscall

    la $a0, opcao2      # Impressao	da frase "Registrar resultado"
    syscall
        
    la $a0, opcao3      # Impressao	da frase "Editar as informações dos times"
    syscall

    la $a0, opcao4      # Impressao	da frase "Gerar o resultado do campeonato na fase eliminatória"
    syscall

    la $a0, opcao5      # Impressao da frase "Sair"
    syscall

    j $ra               # Retorna
    
    # ----------------------------------------------- Função para ler os times -----------------------------------------------
    
  funcao_registrar_times:
    la $a0, informe_nome_time  # Print msg de exibicao
    li $v0, 4
    syscall

    li $v0, 8
    la $a1, tamanho_nome 
    syscall

	  la $a0, time1                   # Le o time 1
	  syscall 

    la $a0, time2                   # Le o time 2
    syscall 

    la $a0, time3                   # Le o time 3
    syscall 

    la $a0, time4                   # Le o time 4
    syscall 

    la $a0, time5                   # Le o time 5
    syscall 

    la $a0, time6                   # Le o time 6
    syscall 
      
    la $a0, time7                   # Le o time 7
    syscall 
      
    la $a0, time8                   # Le o time 8
    syscall 

    la $a0, time9                   # Le o time 9
    syscall 
      
    la $a0, time10                  # Le o time 10
    syscall 

    jr $ra

# ----------------------------------------------- Função para registrar os resultados  -----------------------------------------------
funcao_registrar_resultado:
	addi $t0, $0, 0
	
	sub $sp, $sp, 4     #salva o endereço de retorno na stack
	sw $ra, 0($sp)

	jal imprime_times
	
	addi $t0, $0, 0         # limpa o registrador $t0
	jal adiciona_vencedor

	addi $t0, $0, 0         # limpa o registrador $t0
	jal adiciona_perdedor

	lw $ra, 0($sp)          # Recupera $ra
	addi $sp, $sp, 4	
	jr $ra

# ----------------------------------------------- Função para adicionar vitória  -----------------------------------------------
adicionar_vencedor:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  la $a0, perguntar_time_vencedor
  li $v0, 4
  syscall

  li $v0, 5
  syscall

  addi $t6, $zero, 1
  jal atualizar_resultados_time

  add $t6, $zero, $zero
  jal atualizar_resultados_time

  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra

# ----------------------------------------------- Função para adicionar a derrota  -----------------------------------------------
adiciona_perdedor:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  la $a0, perguntar_time_perdedor
  li $v0, 4
  syscall

  li $v0, 5
  syscall

  addi $t6, $zero, 3
  jal atualizar_resultados_time

  add $t6, $zero, $zero
  jal atualizar_resultados_time

  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra

# --------------------------------------------- FUNCAO ATUALIZAR RESULTADOS DO TIME  ---------------------------------------------
atualizar_resultados_time:
  add $t0, $zero, $v0
  addi $t0, $t0, -1
  
  addi $t1, $zero, 3
  mult $t0, $t1
  mflo $t0

  add $t1, $zero, $t6
  add $t0, $t0, $t1

  sll $t0, $t0, 5

  la $t1, tabela_jogos
  add $t1, $t1, $t0

  lw $t0, 0($t1)
  addi $t0, $t0, 1
  sw $t0, 0($t1)

  jr $ra

#--------------------------------------------- Função para imprimir o nome dos times ---------------------------------------------
imprime_times:
  li $v0, 4

  la $a0, time1             # Imprimir informações do time 1
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time2            # Imprimir informações do time 2
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time3           # Imprimir informações do time 3
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time4         # Imprimir informações do time 4
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time5         # Imprimir informações do time 5
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time6         # Imprimir informações do time 6
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time7            # Imprimir informações do time 7
  syscall

  la $a0, pula_linha         # Pula linha
  syscall   

  la $a0, time8         # Imprimir informações do time 8
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time9         # Imprimir informações do time 9
  syscall

  la $a0, pula_linha         # Pula linha
  syscall

  la $a0, time10           # Imprimir informações do time  10
  syscall

  la $a0, pula_linha        # Pula linha
  syscall

  jr $ra

#--------------------------------------------- Função para menu de edição ---------------------------------------------

editarMenu:



#--------------------------------------------- Função para editar o nome dos times ---------------------------------------------

editarNome:

	addi $t0, $0, 0
	
	sub $sp, $sp, 4             #salva RA na stack
	sw $ra, 0($sp)

LOOP_3:
	addi $t0, $t0, 1

	li $v0, 1
	add $a0, $t0, $0           # Print numero
	syscall

	# Print hifen
	#la $a0, hyphen
	#li $v0, 4
	#syscall
	
	jal imprime_times

	li $v0, 4           # Print nome do time
	syscall
	
	la $a0, pula_linha
	li $v0, 4                   # Imprime o pula linha
	syscall

	bne $t0, 10, LOOP_3

	#printar "qual time quer trocar o nome?"
	la $a0, menuItem3_1_1
	li $v0, 4
	syscall

	# Receber valor
	li $v0, 5
	syscall
	add $t0, $, $v0

	#printar "qual o nome?"
	la $a0, menuItem3_1_2
	li $v0, 4
	syscall

	# Carrega instrucao de leitura
	li $v0, 8
	la $a1, timeCharSize

	#recupera $ra
	lw $ra, 0($sp)
	add $sp, $sp, 4
	
leNovoNome:
    li $t1,1
    bne $t0, $t1, leNovoNome2
	la $a0, time1
	syscall 
    jr $ra

leNovoNome2:
    li $t1,2
    bne $t0, $t1, leNovoNome3
	la $a0, time2
	syscall 
    jr $ra

leNovoNome3:
    li $t1,3
    bne $t0, $t1, leNovoNome4
	la $a0, time3
	syscall 
    jr $ra

leNovoNome4:
    li $t1,4
    bne $t0, $t1, leNovoNome5
	la $a0, time4
	syscall 
    jr $ra

leNovoNome5:
    li $t1,5
    bne $t0, $t1, leNovoNome6
	la $a0, time5
	syscall 
    jr $ra

leNovoNome6:
    li $t1,6
    bne $t0, $t1, leNovoNome7
	la $a0, time6
	syscall 
    jr $ra

leNovoNome7:
    li $t1,7
    bne $t0, $t1, leNovoNome8
	la $a0, time7
	syscall 
    jr $ra

leNovoNome8:
    li $t1,8
    bne $t0, $t1, leNovoNome9
	la $a0, time8
	syscall 
    jr $ra

leNovoNome9:
    li $t1,9
    bne $t0, $t1, leNovoNome10
	la $a0, time9
	syscall 
    jr $ra

leNovoNome10:
	la $a0, time10
	syscall 
    jr $ra