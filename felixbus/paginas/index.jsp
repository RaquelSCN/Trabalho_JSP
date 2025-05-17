<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
/*<%@ include file="basedados/basedados.h" %>
<%@ page import="java.util.ArrayList" %>

<%
// Verificar se o usuário está logado
String perfil = (String) session.getAttribute("perfil");
boolean isLoggedIn = perfil != null && !perfil.isEmpty();

// Obter alertas ativos
ArrayList<String[]> alertas = new ArrayList<>();
try (Connection conn = BaseDados.getConnection();
     Statement stmt = conn.createStatement();
     ResultSet rs = stmt.executeQuery("SELECT titulo, mensagem FROM alertas WHERE ativo = TRUE AND data_inicio <= CURDATE() AND data_fim >= CURDATE()")) {
    while (rs.next()) {
        String[] alerta = {rs.getString("titulo"), rs.getString("mensagem")};
        alertas.add(alerta);
    }
} catch (SQLException e) {
    e.printStackTrace();
}
%>*/

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FelixBus - Gestão de Viagens</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background-color: #003366; color: white; padding: 10px 20px; }
        nav { background-color: #f0f0f0; padding: 5px 20px; }
        .container { padding: 20px; }
        .alert { background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 10px; margin-bottom: 20px; }
        footer { background-color: #003366; color: white; text-align: center; padding: 10px; position: fixed; bottom: 0; width: 100%; }
    </style>
</head>
<body>
    <header>
        <h1>FelixBus</h1>
        <p>Sua viagem mais confortável</p>
    </header>
    
    <nav>
        <a href="index.jsp">Home</a> |
        <a href="rotas.jsp">Rotas e Horários</a> |
        <% if (isLoggedIn) { %>
            <a href="logout.jsp">Logout</a> |
            <% if (perfil.equals("cliente")) { %>
                <a href="cliente/dashboard.jsp">Área do Cliente</a>
            <% } else if (perfil.equals("funcionario")) { %>
                <a href="funcionario/dashboard.jsp">Área do Funcionário</a>
            <% } else if (perfil.equals("admin")) { %>
                <a href="admin/dashboard.jsp">Área de Administração</a>
            <% } %>
        <% } else { %>
            <a href="login.jsp">Login</a> |
            <a href="registo.jsp">Registo</a>
        <% } %>
    </nav>
    
    <div class="container">
        <% if (!alertas.isEmpty()) { %>
            <div class="alert">
                <h3>Alertas e Promoções</h3>
                <% for (String[] alerta : alertas) { %>
                    <div>
                        <strong><%= alerta[0] %></strong>
                        <p><%= alerta[1] %></p>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <h2>Bem-vindo ao FelixBus</h2>
        <p>Oferecemos serviços de transporte de autocarro confortáveis e pontuais entre as principais cidades do país.</p>
        
        <h3>Sobre Nós</h3>
        <p>Localização: Rua dos Autocarros, 123, Lisboa</p>
        <p>Contacto: +351 123 456 789 | info@felixbus.com</p>
        <p>Horário de Funcionamento: Segunda a Domingo, 8h-20h</p>
    </div>
    
    <footer>
        &copy; 2024 FelixBus - Todos os direitos reservados
    </footer>
</body>
</html>