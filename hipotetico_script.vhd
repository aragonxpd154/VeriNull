-- Definição da entidade do controlador adaptativo
entity ControladorAdaptativo is
    Port (
        clk     : in  std_logic;     -- Sinal de clock
        reset   : in  std_logic;     -- Sinal de reset
        entrada : in  std_logic_vector(7 downto 0);   -- Entrada do sistema
        saida   : out std_logic_vector(7 downto 0)   -- Saída do controlador
    );
end ControladorAdaptativo;

-- Arquitetura do controlador adaptativo
architecture Behavioral of ControladorAdaptativo is
    signal erro      : std_logic_vector(7 downto 0);   -- Sinal de erro
    signal coeficientes : std_logic_vector(7 downto 0) := (others => '0');   -- Coeficientes do filtro adaptativo (inicializados com 0)
    signal acumulador : std_logic_vector(7 downto 0) := (others => '0');   -- Acumulador para cálculo dos coeficientes
    signal x          : std_logic_vector(7 downto 0);   -- Sinal de entrada do sistema
    signal y          : std_logic_vector(7 downto 0);   -- Sinal de saída do controlador
    constant mu       : real := 0.01;   -- Taxa de aprendizado do LMS

begin
    -- Processo de atualização do filtro adaptativo
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then   -- Se o sinal de reset estiver ativo, reiniciar os coeficientes e o acumulador
                coeficientes <= (others => '0');
                acumulador <= (others => '0');
            else
                x <= entrada;   -- Atualizar o valor de x com a entrada do sistema
                y <= coeficientes;   -- Atualizar o valor de y com os coeficientes do filtro adaptativo
                erro <= x - y;   -- Calcular o erro como a diferença entre a entrada e a saída do controlador
                acumulador <= acumulador + (erro * std_logic_vector(to_unsigned(to_integer(unsigned(x)), 8))) * std_logic_vector(to_unsigned(to_integer(unsigned(x)), 8)));   -- Atualizar o acumulador com o produto do erro e da entrada, multiplicados por um fator de aprendizado
                coeficientes <= std_logic_vector(to_unsigned(to_integer(unsigned(coeficientes)), 8) + round(mu * to_real(to_integer(unsigned(acumulador)))));   -- Atualizar os coeficientes com o valor anterior mais o valor do acumulador multiplicado pela taxa de aprendizado
            end if;
        end if;
    end process;

    saida <= y;   -- Atribuir o valor de y à saída do controlador

end Behavioral;
