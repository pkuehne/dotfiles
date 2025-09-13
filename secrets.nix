# agenix index file
let
  # Put your age recipients here (add more for other users/hosts)
  myRecipients =
    [ "age1kz9nklxfscms6x5ej4j8taqcadgcrtfmaa540624ymnkd0u9lptqa6qnpt" ];
in {
  # Map a logical secret name to:
  # - path of the encrypted file in your repo, and
  # - who can decrypt it (recipients)
  "secrets/id_peter.age".publicKeys = myRecipients;
}

