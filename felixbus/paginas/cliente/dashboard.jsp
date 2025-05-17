<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../basedados/basedados.h" %>

<%
// Verificar se o usuário está logado como cliente
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equals("cliente")) {
    response.sendRedirect("../../login.jsp");
    return;
}

String username = (String) session.getAttribute("username");

// Obter informações do cliente
double saldo = 0;
int bilhetesAtivos = 0;

try (Connection conn = BaseDados.getConnection()) {
    // Obter saldo da carteira
    String sqlSaldo = "SELECT c.saldo FROM carteiras c JOIN clientes cl ON c.cliente_id = cl.utilizador_id JOIN utilizadores u ON cl.utilizador_id = u.id WHERE u.username = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sqlSaldo)) {
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            saldo = rs.getDouble("saldo");
        }
    }
    
    // Obter número de bilhetes ativos
    String sqlBilhetes = "SELECT COUNT(*) AS total FROM bilhetes b JOIN clientes cl ON b.cliente_id = cl.utilizador_id JOIN utilizadores u ON cl.utilizador_id = u.id WHERE u.username = ? AND b.estado = 'pago' AND b.data_viagem >= CURDATE()";
    try (PreparedStatement stmt = conn.prepareStatement(sqlBilhetes)) {
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            bilhetesAtivos = rs.getInt("total");
        }
    }
} catch (SQLException e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Área do Cliente - FelixBus</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background-color: #003366; color: white; padding: 10px 20px; }
        nav { background-color: #f0f0f0; padding: 5px 20px; }
        .container { padding: 20px; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
        .dashboard-card { background: white; border-radius: 5px; box-shadow: 0 0 5px rgba(0,0,0,0.1); padding: 20px; }
        .dashboard-card h3 { margin-top: 0; color: #003366; }
        .saldo { font-size: 24px; font-weight: bold; color: #003366; }
        footer { background-color: #003366; color: white; text-align: center; padding: 10px; position: fixed; bottom: 0; width: 100%; }
    </style>
</head>
<body>
    <header>
        <h1>FelixBus - Área do Cliente</h1>
        <p>Bem-vindo, <%= username %></p>
    </header>
    
    <nav>
        <a href="../../index.jsp">Home</a> |
        <a href="../../logout.jsp">Logout</a> |
        <a href="dashboard.jsp">Dashboard</a> |
        <a href="perfil.jsp">Meu Perfil</a> |
        <a href="carteira.jsp">Minha Carteira</a> |
        <a href="bilhetes.jsp">Meus Bilhetes</a> |
        <a href="../../rotas.jsp">Comprar Bilhetes</a>
    </nav>
    
    <div class="container">
        <h2>Dashboard</h2>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Minha Carteira</h3>
                <p class="saldo"><%= String.format("%.2f €", saldo) %></p>
                <a href="carteira.jsp">Gerir Carteira</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Meus Bilhetes</h3>
                <p>Bilhetes ativos: <%= bilhetesAtivos %></p>
                <a href="bilhetes.jsp">Ver Todos os Bilhetes</a>
            </div>
        </div>
    </div>
    
    <footer>
        &copy; 2024 FelixBus - Todos os direitos reservados
    </footer>
</body>
</html>