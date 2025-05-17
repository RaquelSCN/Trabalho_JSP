<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../basedados/basedados.h" %>

<%
// Verificar se o usuário está logado como admin
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equals("admin")) {
    response.sendRedirect("../../login.jsp");
    return;
}

String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Painel de Administração - FelixBus</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background-color: #003366; color: white; padding: 10px 20px; }
        nav { background-color: #f0f0f0; padding: 5px 20px; }
        .container { padding: 20px; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .dashboard-card { background: white; border-radius: 5px; box-shadow: 0 0 5px rgba(0,0,0,0.1); padding: 20px; }
        .dashboard-card h3 { margin-top: 0; color: #003366; }
        footer { background-color: #003366; color: white; text-align: center; padding: 10px; position: fixed; bottom: 0; width: 100%; }
    </style>
</head>
<body>
    <header>
        <h1>FelixBus - Painel de Administração</h1>
        <p>Bem-vindo, <%= username %></p>
    </header>
    
    <nav>
        <a href="../../index.jsp">Home</a> |
        <a href="../../logout.jsp">Logout</a> |
        <a href="dashboard.jsp">Dashboard</a> |
        <a href="gerir_rotas.jsp">Gerir Rotas</a> |
        <a href="gerir_utilizadores.jsp">Gerir Utilizadores</a> |
        <a href="gerir_alertas.jsp">Gerir Alertas</a>
    </nav>
    
    <div class="container">
        <h2>Dashboard</h2>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Rotas</h3>
                <%
                int totalRotas = 0;
                try (Connection conn = BaseDados.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM rotas WHERE ativo = TRUE")) {
                    if (rs.next()) {
                        totalRotas = rs.getInt("total");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
                <p>Total de rotas ativas: <%= totalRotas %></p>
                <a href="gerir_rotas.jsp">Gerir Rotas</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Utilizadores</h3>
                <%
                int totalClientes = 0;
                int totalFuncionarios = 0;
                try (Connection conn = BaseDados.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT perfil, COUNT(*) AS total FROM utilizadores WHERE ativo = TRUE GROUP BY perfil")) {
                    while (rs.next()) {
                        if (rs.getString("perfil").equals("cliente")) {
                            totalClientes = rs.getInt("total");
                        } else if (rs.getString("perfil").equals("funcionario")) {
                            totalFuncionarios = rs.getInt("total");
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
                <p>Clientes: <%= totalClientes %></p>
                <p>Funcionários: <%= totalFuncionarios %></p>
                <a href="gerir_utilizadores.jsp">Gerir Utilizadores</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Bilhetes</h3>
                <%
                int bilhetesVendidos = 0;
                try (Connection conn = BaseDados.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM bilhetes WHERE estado = 'pago'")) {
                    if (rs.next()) {
                        bilhetesVendidos = rs.getInt("total");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
                <p>Bilhetes vendidos: <%= bilhetesVendidos %></p>
            </div>
        </div>
    </div>
    
    <footer>
        &copy; 2024 FelixBus - Todos os direitos reservados
    </footer>
</body>
</html>