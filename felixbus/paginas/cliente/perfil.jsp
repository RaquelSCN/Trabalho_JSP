<%@ include file="../basedados.h" %>
<%
    if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("cliente")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("id");
    String nome = "", email = "";
    String mensagem = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        nome = request.getParameter("nome");
        email = request.getParameter("email");

        PreparedStatement update = conn.prepareStatement("UPDATE utilizadores SET nome=?, email=? WHERE id=?");
        update.setString(1, nome);
        update.setString(2, email);
        update.setInt(3, userId);
        update.executeUpdate();

        mensagem = "Dados atualizados com sucesso!";
    }

    PreparedStatement stmt = conn.prepareStatement("SELECT nome, email FROM utilizadores WHERE id=?");
    stmt.setInt(1, userId);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
        nome = rs.getString("nome");
        email = rs.getString("email");
    }
%>

<html>
<head><title>Perfil do Cliente</title></head>
<body>
    <h2>Perfil</h2>
    <form method="post">
        Nome: <input type="text" name="nome" value="<%= nome %>" required><br>
        Email: <input type="email" name="email" value="<%= email %>" required><br>
        <input type="submit" value="Atualizar">
    </form>

    <% if (!mensagem.isEmpty()) { %>
        <p style="color:green;"><%= mensagem %></p>
    <% } %>

    <p><a href="dashboard.jsp">Voltar</a></p>
</body>
</html>
