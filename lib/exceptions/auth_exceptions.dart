class AuthException implements Exception{

   static const Map<String, String> erros = {
     "EMAIL_EXISTS": "E-mail já existente",
     "OPERATION_NOT_ALLOWED": "Operação não permitida",
     "TOO_MANY_ATTEMPTS_TRY_LATER": "Muitas tentativas para entrar",
     "EMAIL_NOT_FOUND": "E-mail e/ou senha inválidos",
     "INVALID_PASSWORD": "E-mail e/ou senha inválidos",
     "USER_DISABLED": "Usuário desabilitado",
     "INVALID_EMAIL": "E-mail e/ou senha inválidos"
   };

  final String key;

  const AuthException(this.key);

  @override
  String toString(){
    if(erros.containsKey(key)){
      return erros[key];
    }else{
      return "Ocorreu um erro inesperado na autenticação";
    }
  }
}