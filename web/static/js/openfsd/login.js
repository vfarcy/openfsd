$("#login-form").on("submit", (ev) => {
    ev.preventDefault();

    const requestBody = {
        'cid': parseInt($("#login-input-cid").val()),
        'password': $("#login-input-password").val(),
        'remember_me': $("#login-form-remember-me").prop('checked')
    }

    $.ajax("/api/v1/auth/login", {
        method: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(requestBody)
    }).then((res) => {
        console.log("API login response:", res);
        if (res && res.err) {
            alert("Erreur d'authentification: " + res.err);
            console.error("Erreur API:", res.err);
            return;
        }
        if (!res || !res.data || !res.data.access_token) {
            alert("Réponse API inattendue. Veuillez réessayer.");
            console.error("Réponse API inattendue:", res);
            return;
        }
        localStorage.setItem("access_token", res.data.access_token)
        localStorage.setItem("refresh_token", res.data.refresh_token)
        window.location.href = "/dashboard"
    }).fail((xhr) => {
        let errMsg = "Erreur inconnue";
        if (xhr.responseJSON && xhr.responseJSON.err) {
            errMsg = xhr.responseJSON.err;
        } else if (xhr.statusText) {
            errMsg = xhr.statusText;
        }
        alert(`Échec de la connexion: ${errMsg}`);
        console.error("Échec AJAX login:", xhr);
    })
})
