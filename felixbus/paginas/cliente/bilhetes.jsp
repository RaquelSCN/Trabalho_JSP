<%@ include file="../basedados.h" %>
<%
    if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("cliente")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("id");
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT b.codigo_bilhete, h.data, h.hora, r.origem, r.destino FROM bilhetes b " +
        "JOIN horarios h ON b.horario_id = h.id " +
        "JOIN rotas r ON h.rota_id = r.id WHERE b.utilizador_id = ?"
    );
    stmt.setInt(1, userId);
    ResultSet rs = stmt.executeQuery();
%>

<html>
<head><title>Meus Bilhetes</title></head>
<body>
    <h2>Meus Bilhetes</h2>
    <table border="1">
        <tr><th>Código</th><th>Origem</th><th>Destino</th><th>Data</th><th>Hora</th></tr>
        <%
            while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getString("codigo_bilhete") %></td>
                <td><%= rs.getString("origem") %></td>
                <td><%= rs.getString("destino") %></td>
                <td><%= rs.getDate("data") %></td>
                <td><%= rs.getTime("hora") %></td>
            </tr>
        <%
            }
        %>
    </table>
    <p><a href="dashboard.jsp">Voltar</a></p>
</body>
</html>
