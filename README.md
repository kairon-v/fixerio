# fixerio

## Sobre

O código foi escrito em ruby. Foi criada uma classe chamada FixerIo. Na classe há vários métodos que desempenham funções específicas. Foi feito dessa forma para que o código fique melhor organizado.

O fluxo normal do script é:  

1. Instanciar: seta a base para USD e a conversão para BRL. Define a soma das taxas para o período como zero.
2. Datas: seta as datas de início e fim. As datas são usadas para calcular o período durante o qual se deseja obter as taxas.
3. Calcular: o método `calculate!` chama outros métodos para obter os dias no período (ignorando finais de semana), obtém a taxa cambial para cada dia, atualiza os valores mínimos e máximos no período observado e atualiza a o valor total das taxas para que seja possível calcular a taxa média do período.

**A taxa média ignora a data de início e fim, além dos finais de semana.**


## Executar
Para simplificar, o script é instanciado e chamado no mesmo arquivo.

Deve-se Rodar o comando `ruby fixerio.rb` na mesma pasta do arquivo.

## Questões
1. Em qual dia foi observado o menor valor? Data: (2011-07-26)  Taxa: R$ 1,5347.

2. Em qual dia foi observado a maior valor? Data: (2011-09-23)  Taxa: R$ 1,9111.

3. Qual é a média da cotação para esse período, excetuando os dias de início e fim? Taxa: 1,7204.
