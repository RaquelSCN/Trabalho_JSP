<%@ include file="../basedados.h" %>
<%
    if (session.getAttribute("tipo") == null || !session.getAttribute("tipo").equals("cliente")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("id");
    double saldo = 0.0;
    String mensagem = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        double valor = Double.parseDouble(request.getParameter("valor"));
        String operacao = request.getParameter("operacao");

        if (operacao.equals("adicionar")) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE utilizadores SET saldo = saldo + ? WHERE id=?");
            stmt.setDouble(1, valor);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } else if (operacao.equals("levantar")) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE utilizadores SET saldo = saldo - ? WHERE id=? AND saldo >= ?");
            stmt.setDouble(1, valor);
            stmt.setInt(2, userId);
            stmt.setDouble(3, valor);
            stmt.executeUpdate();
        }
        mensagem = "Operação efetuada com sucesso!";
    }

    PreparedStatement saldoStmt = conn.prepareStatement("SELECT saldo FROM utilizadores WHERE id=?");
    saldoStmt.setInt(1, userId);
    ResultSet rs = saldoStmt.executeQuery();
    if (rs.next()) {
        saldo = rs.getDouble("saldo");
    }
%>

<html>
<head><title>Carteira</title></head>
<body>
    <h2>Saldo atual: <%= saldo %> €</h2>

    <form method="post">
        Valor: <input type="number" name="valor" min="0" step="0.01" required><br>
        <input type="submit" name="operacao" value="adicionar">
        <input type="submit" name="operacao" value="levantar">
    </form>

    <% if (!mensagem.isEmpty()) { %>
        <p style="color:green;"><%= mensagem %></p>
    <% } %>

    <p><a href="dashboard.jsp">Voltar</a></p>
</body>
</html>
