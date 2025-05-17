<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%@ include file="basedados.h" %>

<%
    String mensagem = "";

    // Função para encriptar a password com SHA-256
    String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if(hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    // Processamento do login
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String hashedPassword = hashPassword(password);

            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM utilizadores WHERE username=? AND password=? AND ativo=TRUE"
            );
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
                // Sessão iniciada
                session.setAttribute("id", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("tipo", rs.getString("tipo"));

                String tipo = rs.getString("tipo");

                if(tipo.equals("admin")) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else if(tipo.equals("funcionario")) {
                    response.sendRedirect("funcionario/dashboard.jsp");
                } else {
                    response.sendRedirect("cliente/dashboard.jsp");
                }
                return;
            } else {
                mensagem = "Credenciais inválidas ou utilizador inativo.";
            }
        } catch (Exception e) {
            mensagem = " Erro interno: " + e.getMessage();
        }
    }
%>

<html>
<head><title>Login - FelixBus</title></head>
<body>
    <h2>Login</h2>
    <form method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Entrar">
    </form>

    <% if (!mensagem.isEmpty()) { %>
        <p style="color:<%= cor %>;"><%= mensagem %></p>
    <% } %>

    <p>Ainda não tem conta? <a href="registo.jsp">Registar</a></p>
</body>
</html>
