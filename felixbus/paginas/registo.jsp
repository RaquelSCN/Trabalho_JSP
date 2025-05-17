<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%@ include file="basedados.h" %>

<%
    String mensagem = "";
    String color = "red"; // cor padrão para mensagens de erro

    // Função de encriptação da password com SHA-256
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

    if(request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");

        // Verificar se username já existe
        PreparedStatement check = conn.prepareStatement("SELECT id FROM utilizadores WHERE username=?");
        check.setString(1, username);
        ResultSet rs = check.executeQuery();

        if(rs.next()) {
            mensagem = " Nome de utilizador já existe.";
        } else {
            try {
                String hashedPassword = hashPassword(password);

                PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO utilizadores (username, password, nome, email, tipo, ativo) VALUES (?, ?, ?, ?, 'cliente', TRUE)"
                );
                insert.setString(1, username);
                insert.setString(2, hashedPassword);
                insert.setString(3, nome);
                insert.setString(4, email);
                insert.executeUpdate();

                mensagem = " Registo efetuado com sucesso. Pode agora fazer login.";
                color = "green";
            } catch (Exception e) {
                mensagem = " Erro ao registar: " + e.getMessage();
            }
        }
    }
%>

<html>
<head><title>Registo de Cliente</title></head>
<body>
    <h2>Registo</h2>
    <form method="post">
        Nome: <input type="text" name="nome" required><br>
        Email: <input type="email" name="email" required><br>
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Registar">
    </form>

    <% if (!mensagem.isEmpty()) { %>
        <p style="color:<%= cor %>;"><%= mensagem %></p>
    <% } %>

    <p><a href="login.jsp">Voltar ao login</a></p>
</body>
</html>
