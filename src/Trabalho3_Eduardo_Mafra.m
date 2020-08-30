%%
%  
%  Laborat�rio 3 - Vis�o Computacional.
%  Aluno: Eduardo Mafra Pereira.
%  email: emafra0@gmail.com.
%  Quest�o 1.
%  Neste problema foi preciso realizar a equaliza��o de imagem, processo
%  muito �til para suavizar imagens muito "densas". Para solucionar o
%  problema foi ultilizado o comando "histeq", este comando atua 
%  diretamente no histograma ("espectro") da imagem disper�ando suas 
%  componentes. Ou seja, equalizando ela.
% 

clear all
clc
Im1 = imread('HistEq.jpg'); % Chamada da imagem.
Im1 = rgb2gray(Im1); % Transforma a imagem para a escala Gray.
figure(1),imhist(Im1); % Plota o histograma da figura Im1.
title('Histograma da Imagem 1')
J = histeq(Im1); % Atribui a imagem equalizada a vari�vel J.
figure(2),imshowpair(Im1,J,'montage'); 
title('Imagem 1 "Sem" e "Com" Aplica��o do Histograma');
figure(3),imhist(J); % Histograma da imagem equalizada.
title('Histograma da Imagem 1 Equalizada');
%  
%  Processo se repete para as outras duas imagens.
%  Imagem 2: 
Im2 = imread('HistEq2.jpg'); % Chamada da imagem.
Im2 = rgb2gray(Im2); % Transforma a imagem para a escala Gray.
figure(4),imhist(Im2); % Plota o histograma da figura Im2.
title('Histograma da Imagem 2')
J = histeq(Im2); % Atribui a imagem equalizada a vari�vel J.
figure(5),imshowpair(Im2,J,'montage'); 
title('Imagem 2 "Sem" e "Com" Aplica��o do Histograma');
figure(6),imhist(J); % Histograma da imagem equalizada.
title('Histograma da Imagem 2 Equalizada');
%  Imagem 3:
Im3 = imread('HistEq3.jpg'); % Chamada da imagem.
Im3 = rgb2gray(Im3); % Transforma a imagem para a escala Gray.
figure(7),imhist(Im3); % Plota o histograma da figura Im3.
title('Histograma da Imagem 3')
J = histeq(Im3); % Atribui a imagem equalizada a vari�vel J.
figure(8),imshowpair(Im3,J,'montage'); 
title('Imagem 3 "Sem" e "Com" Aplica��o do Histograma');
figure(9),imhist(J); % Histograma da imagem equalizada.
title('Histograma da Imagem 3 Equalizada');
%%
% 
%  Quest�o 2.
%   O objetivo desta etapa era desenvolver um algoritmo que conseguisse
%  contar dinheiro em uma imagem. Para a solu��o do problema foi proposto o
%  algoritmo a seguir. Este transforma a imagem original em uma imagem
%  preto e branco e homogeneizam a imagem gerada para deixa-l� mais 
%  uniforme.
%   A imagem gerada � passada por um la�o removedor de ru�dos, e na
%  sequ�ncia transformada para uma imagem indexada. O objetivo deste
%  processo � que imagens indexadas proporcionam uma diferencia��o de
%  objetos.
%   Com a imagem j� indexada s�o atribu�dos as quantidades de pixels de
%  cada objeto a uma lista "tam[]". Com as quantidades j� atribuidas a
%  lista, esta � aplicada em um la�o de repeti��o que compara os valores
%  de cada elemento da lista afim de contar a quantidade de elementos de
%  mesmo tamanho que a lista cont�m. E finalmente s�o atribuidos os pesos 
%  das moedas a cada quantidade de objetos equivalentes, proporcionando 
%  assim o c�lculo do dinheiro total presente na imagem.
% 

clear all
clc
Im1 = imread('Moedas.jpg'); % Chamada da imagem.
R= double(Im1(:,:,1));
G= double(Im1(:,:,2));
B= double(Im1(:,:,3));
Im1 = rgb2gray(Im1); % Transforma��o a imagem de RGB para GRAY.
Im1 = Im1-110; % Equaliza a imagem.
ImHBW = im2bw(Im1); % Transforma da escala Gray para preto e Branco.
imshow(ImHBW); % Mostra a imagem em escala preto e branco homogeneizada
title("Imagem em escala preto e branco homogeneizada")
Im_Bin = not(ImHBW); % Invers�o das cores da imagem. 
flag=0;
for i=2:1:length(Im_Bin(:,1))-1 % La�o para eliminar ru�do
    for j=2:1:length(Im_Bin(1,:))-1       
        flag=0;
        for k=-1:1
            for c=-1:1
                if Im_Bin(i+k,j+c)==1
                   flag=flag+1;
                end
            end
        end
        if flag < 3 % Se o pixel n�o tiver ao menos 3 pixles brancos ao seu
                    %redor, este pixel � "eliminado".
           Im_Bin(i,j)=0; % "Elimina" pixel.
        end
    end
end
%   Transforma a imagem preto e branco em uma imagem double indexada.
%   A vari�vel num apresenta a quantidades de �ndices atribuidos a imagem
% ou seja, a quantidade de "objetos" presentes na imagem.
[Im_Label,num] = bwlabel(Im_Bin,8);  
Im_Lab=Im_Label;
imshow(Im_Lab);
title('Imagem Indexada');
%N = max(max(Im_Lab)); 
tam=[]; % Lista para atribuir a quantidade de pixels para cada �ndice
%(tamanho do objeto).
for i=1:1:num
    [rows,cols,vals] = find(Im_Lab==i);
    [t,c]=size(rows); % atribui a quantidade de �ndices a vari�vel t.
    tam(i)= t;
end
tam_n=tam;
valores=[]; % Lista para conter a quantidade de "objetos" com mesmo 
% "tamanho". 
list=[];
for i = 1:1:num
    count=0;
    a = tam_n(i);
    for q = 1:1:num
        %   Se os objetos possuem uma quantidade de pixels similar ao 
        %  �ndice proposto (margem de 5%), a quantidade de objetos �
        %  calculada.
        if tam_n(q) >= (a*0.95) & tam(q) <= (a*1.05)
            count = count +1; % Contador de n�mero de objetos.
            tam_n(q)=0; % Zera os �ndices que j� foram contados.
        end      
        if q == num
            valores(i) = count; % Atribui a quantidade de objetos similares
                                %  lista valores[].
        end       
    end  
        
end
elementos=[]; % Lista que relaciona os �ndices aos objetos encontrados
p=1;
for i = 1:1:num
    b=valores(i);
    if b > 0 % Se o �ndice n�o foi zerado
       elementos(p)=i; % Atribui-se a posi��o deste �ndice na lista 
                       %  "valores" para a lista "elementos".
       p=p+1; % Tamanho da lista elementos -1.
    end
end
for i = 1:1:p-1 
    a = elementos(i);
    flag=0;
    for q= 1:1:p-1 % Compara quais objetos tem mais pixels ("maior 
                   %  tamanho").
        b = elementos(q);
        if tam(a)>tam(b)
            flag=flag+1;
        end        
    end
    if flag == 4 % Condi��es para atribuir os pesos das moedas conforme o 
                 %  "tamanho".
        RS1= tam(a);
        QRS1= valores(a);
    end
    if flag == 3
        RS0_50= tam(a);
        QRS0_50= valores(a);
    end
    if flag == 2
        RS0_25= tam(a);
        QRS0_25= valores(a);
    end
    if flag == 1
        RS0_10= tam(a);
        QRS0_10= valores(a);
    end
    if flag == 0
        RS0_05= tam(a);
        QRS0_05= valores(a);
    end
end
% Valor total calculado.
Total=QRS1+(0.5*QRS0_50)+(0.25*QRS0_25)+(0.1*QRS0_10)+(0.05*QRS0_05) 
    
    %%
% 
%  Quest�o 3.
%    Na etapa 3 foi proposto apagar uma tatuagem utilizando m�scaras de
%   suaviza��o. Sendo assim, foi criada uma m�scara de suaviza��o e esta
%   ser� aplicada apenas quando os valores presentes nas matrizes RGB forem
%   maiores que 180. Ou seja, filtro aplicado apenas nos pixels mais
%   escuros.
% 

clear all
clc
Im1 = imread('Tatoo1.jpg');
%Img = rgb2gray(Im1);

figure(1),imshow(Im1); % captura dois pontos na imagem para processar a 
% reduzida. S� a parte da tatuagem.
title('Imagem original');
[x y] = ginput(2);

%Redu��o da imagem
Im(:,:,1)=Im1(y(1):y(2),x(1):x(2),1);
Im(:,:,2)=Im1(y(1):y(2),x(1):x(2),2);
Im(:,:,3)=Im1(y(1):y(2),x(1):x(2),3);
%figure(2),imshow(Im);
[n m c] = size(Im); % Escolha de dois pontos que ir�o ditar o tamanho da 
% nova imagem.
figure(2),imshow(Im);
title('Imagem recortada');

Mask=ones(3,3); %cria��o da m�scara de suaviza��o.
div=9;
z=2;

Imagem=double(Im);
Ir(:,:,1)=Imagem(:,:,1);
Ig(:,:,2)=Imagem(:,:,2);
Ib(:,:,3)=Imagem(:,:,3);

 % la�o para repetir o procedimento 3 vezes. Um la�o para cada
    % profunfidade da matriz (RGB).

for f=1:1:40 % repete a aplica��o do filtro 40 vezes para cada matriz RGB 
    % da imagem processada.
    for i=z:1:n-z
       for j=z:1:m-z
            val=0;
          % Condi��o if para aplicar o filtro apenas nos pixels mais
          % escuros, ou seja, na tatuagem.
          if Im(i,j,1)<180 || Im(i,j,2)<180 || Im(i,j,3)<180
           
           % Realiza o somat�rio das convolu��es realizadas em cada
           % profundidade RGB.
           Ir(i,j)= sum(sum(double(Imagem(i-1:i+1,j-1:j+1,1).*Mask(:,:))));
           Ig(i,j)= sum(sum(double(Imagem(i-1:i+1,j-1:j+1,2).*Mask(:,:))));
           Ib(i,j)= sum(sum(double(Imagem(i-1:i+1,j-1:j+1,3).*Mask(:,:))));
            
           
           Imagem(i,j,1) = uint8(Ir(i,j)/div); %Atribui a m�dia dos pixels
           % a aos a imagem gerada.
           
             
           Imagem(i,j,2) = uint8(Ig(i,j)/div);
          
          
           Imagem(i,j,3) = uint8(Ib(i,j)/div);
           
          end
          
    end
end

end
result(:,:,1)=Imagem(:,:,1);
result(:,:,2)=Imagem(:,:,2);
result(:,:,3)=Imagem(:,:,3);
[z,h]=size(result);
Im2=Im1;
% Faz a jun��o da imagem recortada com a imagem original.
Im2(y(1)+7:y(2)-7,x(1)+7:x(2)-7,1)=result(8:z-7,8:(h/3)-7,1);
Im2(y(1)+7:y(2)-7,x(1)+7:x(2)-7,2)=result(8:z-7,8:(h/3)-7,2);
Im2(y(1)+7:y(2)-7,x(1)+7:x(2)-7,3)=result(8:z-7,8:(h/3)-7,3);

figure(3),imshow(Im2);
title('Resultado Final');
%%
% 
%  Quest�o 4
%  Para a etapa 4 foi solicitado realizar um realce de imagem atrav�s de
%  aplica��o de m�scaras de realce. Sendo assim, foram propostas 3
%  m�scaras para a solu��o do problema. Estas ser�o convolucionadas com a
%  matriz original, e por fim, s�o somadas todas as multiplica��es destes
%  pixels e atribuidas aos elementos centrais do processo.
% 

clear all
clc
Im1 = imread('Burrinhos.jpg');
figure(1),imshow(Im1);
title('Imagem Original');
Mask = 0.1*[1 -2 1; -2 4 -2; 1 -2 1]; % m�scara teste 1
beta= 1;
%Mask = [0 -1 0; -1 4 -1; 0 -1 0]; % m�scara teste 2
%Mask = 0.1*[1 -1 1; -1 4 -1; 1 -1 1]; % m�scara teste 3

result=Im1;
result1=result;
for i =2:length(result(:,1))-1
    for j =2:length(result(1,:))-1
        for e=-1:1
            for r=-1:1
                M(e+2,r+2) = result(e+i,r+j); % pontos da matriz original 
                % atribuidos a uma matriz 3x3.
            end
        end
               
        result1(i,j) = result1(i,j)+ beta*(sum(sum(double(M).*Mask)));
        % Somat�rio dos pontos das matrizes convolucionadas atribuido ao
        % elemento central (i,j) de uma sec��o da matriz "result1".
    end
end
   figure(2),imshow(result1);
   title('Imagem Real�ada'); 
%%
% 
%  Quest�o 5.
%  Para a quinta etapa foi implementado um algoritmo de detec��o de bordas.
% neste foram feitas alguns teste. O primeiro como uma m�scara de detec��o
% qualquer, um segundo teste aplicando uma m�scara de Sobel vertical e
% uma horizontal e por fim o �ltimo teste utilizou 2 m�scaras de Prewitt (
% uma vertical e outra horizontal).
%   A implementa��o do c�digo � apresentada da seguinte maneira:
% 

clear all
clc
Im1 = imread('tom_e_jerry.jpg');
Img = rgb2gray(Im1);
ImHBW = im2bw(Img); % Trnasforma��o da imagem para escala preto e branco.
%Im_Bin = not(ImHBW);
figure(1),imshow(Im1);
Mask = ones(3,3);
Mask(2,2) = -8; % M�scara 1.
prewittv = [1 0 -1; 1 0 -1; 1 0 -1];
prewitth = [-1 -1 -1; 0 0 0; 1 1 1]; % M�scaras de Prewitt.
sobelv = [-1 0 1; -2 0 2; -1 0 1];
sobelh = [-1 -2 -1; 0 0 0; 1 2 1]; % M�scaras de Sobel.
val=0;
result=ImHBW;
[n,m]=size(result);
result1=result;
result2=result;
result3=result;
result4=result;
result5=result;
for i =2:length(result(:,1))-1
    for j =2:length(result(1,:))-1
        for I=-1:1
            for J=-1:1
                M(I+2,J+2) = result(I+i,J+j);
            end
        end
        result1(i,j) = uint8(sum(sum(double(M).*Mask)));
        result2(i,j) = uint8(sum(sum(double(M).*sobelv)));
        result3(i,j) = uint8(sum(sum(double(M).*sobelh)));
        result4(i,j) = uint8(sum(sum(double(M).*prewittv)));
        result5(i,j) = uint8(sum(sum(double(M).*prewitth)));
    end
end
   resultf1=not(result1);%resultado com a m�scara 1
   figure(2),imshow(resultf1);
   title('Resultado da Aplica��o da M�scara 1')
   resultf2=not(result2+result3);%resultado soma de m�scaras de 
   % sobel na horizontal e vertical
   figure(3),imshow(resultf2);
   title('Resultado da Aplica��o das M�scaras de Sobel')
   resultf3=not(result4+result5);%resultado soma de m�scaras de 
   % Prewitt na horizontal e vertical
   figure(4),imshow(resultf3);
   title('Resultado da Aplica��o das M�scaras de Prewitt')
   

