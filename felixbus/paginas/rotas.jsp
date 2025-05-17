<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="basedados/basedados.h" %>

<%
// Obter parâmetros de ordenação e filtro
String ordenarPor = request.getParameter("ordenarPor");
if (ordenarPor == null) ordenarPor = "origem";

String ordem = request.getParameter("ordem");
if (ordem == null) ordem = "ASC";

String origemFiltro = request.getParameter("origem");
String destinoFiltro = request.getParameter("destino");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rotas e Horários - FelixBus</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background-color: #003366; color: white; padding: 10px 20px; }
        nav { background-color: #f0f0f0; padding: 5px 20px; }
        .container { padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #003366; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .filtros { background: white; padding: 15px; margin-bottom: 20px; border-radius: 5px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
        .filtros h3 { margin-top: 0; }
        footer { background-color: #003366; color: white; text-align: center; padding: 10px; position: fixed; bottom: 0; width: 100%; }
    </style>
</head>
<body>
    <header>
        <h1>FelixBus - Rotas e Horários</h1>
    </header>
    
    <nav>
        <a href="index.jsp">Home</a> |
        <a href="rotas.jsp">Rotas e Horários</a> |
        <% if (session.getAttribute("perfil") != null) { %>
            <a href="logout.jsp">Logout</a>
        <% } else { %>
            <a href="login.jsp">Login</a> |
            <a href="registo.jsp">Registo</a>
        <% } %>
    </nav>
    
    <div class="container">
        <div class="filtros">
            <h3>Filtrar Rotas</h3>
            <form method="get">
                <label for="origem">Origem:</label>
                <input type="text" id="origem" name="origem" value="<%= origemFiltro != null ? origemFiltro : "" %>">
                
                <label for="destino">Destino:</label>
                <input type="text" id="destino" name="destino" value="<%= destinoFiltro != null ? destinoFiltro : "" %>">
                
                <input type="submit" value="Filtrar">
                <a href="rotas.jsp">Limpar Filtros</a>
            </form>
        </div>
        
        <h2>Rotas Disponíveis</h2>
        
        <table>
            <tr>
                <th><a href="rotas.jsp?ordenarPor=origem&ordem=<%= ordenarPor.equals("origem") && ordem.equals("ASC") ? "DESC" : "ASC" %>">Origem</a></th>
                <th><a href="rotas.jsp?ordenarPor=destino&ordem=<%= ordenarPor.equals("destino") && ordem.equals("ASC") ? "DESC" : "ASC" %>">Destino</a></th>
                <th>Distância (km)</th>
                <th>Duração (min)</th>
                <th>Horários</th>
                <th>Preços</th>
            </tr>
            
            <%
            try (Connection conn = BaseDados.getConnection()) {
                // Construir a query SQL com filtros e ordenação
                String sql = "SELECT * FROM rotas WHERE ativo = TRUE";
                
                if (origemFiltro != null && !origemFiltro.isEmpty()) {
                    sql += " AND origem LIKE ?";
                }
                if (destinoFiltro != null && !destinoFiltro.isEmpty()) {
                    sql += " AND destino LIKE ?";
                }
                
                sql += " ORDER BY " + ordenarPor + " " + ordem;
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    int paramIndex = 1;
                    if (origemFiltro != null && !origemFiltro.isEmpty()) {
                        stmt.setString(paramIndex++, "%" + origemFiltro + "%");
                    }
                    if (destinoFiltro != null && !destinoFiltro.isEmpty()) {
                        stmt.setString(paramIndex++, "%" + destinoFiltro + "%");
                    }
                    
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        int rotaId = rs.getInt("id");
                        String origem = rs.getString("origem");
                        String destino = rs.getString("destino");
                        double distancia = rs.getDouble("distancia_km");
                        int duracao = rs.getInt("duracao_min");
                        
                        // Obter horários para esta rota
                        String sqlHorarios = "SELECT hora_partida, hora_chegada, preco FROM horarios WHERE rota_id = ? AND ativo = TRUE ORDER BY hora_partida";
                        try (PreparedStatement stmtHorarios = conn.prepareStatement(sqlHorarios)) {
                            stmtHorarios.setInt(1, rotaId);
                            ResultSet rsHorarios = stmtHorarios.executeQuery();
                            
                            StringBuilder horariosHtml = new StringBuilder();
                            StringBuilder precosHtml = new StringBuilder();
                            
                            while (rsHorarios.next()) {
                                String horaPartida = rsHorarios.getString("hora_partida");
                                String horaChegada = rsHorarios.getString("hora_chegada");
                                double preco = rsHorarios.getDouble("preco");
                                
                                horariosHtml.append(horaPartida.substring(0, 5)).append(" - ").append(horaChegada.substring(0, 5)).append("<br>");
                                precosHtml.append(String.format("%.2f €", preco)).append("<br>");
                            }
                            
                            if (horariosHtml.length() == 0) {
                                horariosHtml.append("Nenhum horário disponível");
                                precosHtml.append("N/A");
                            }
            %>
                            <tr>
                                <td><%= origem %></td>
                                <td><%= destino %></td>
                                <td><%= String.format("%.1f", distancia) %></td>
                                <td><%= duracao %></td>
                                <td><%= horariosHtml.toString() %></td>
                                <td><%= precosHtml.toString() %></td>
                            </tr>
            <%
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            %>
        </table>
    </div>
    
    <footer>
        &copy; 2024 FelixBus - Todos os direitos reservados
    </footer>
</body>
</html>