package org.lucassouza.jsopt.json2xls;

import java.util.LinkedList;
import java.util.List;
import org.json.JSONArray;

/**
 *
 * @author Lucas Souza [sorackb@gmail.com]
 *
 * Utilizado na resposta para a pergunta "JSON para XLS em java":
 * https://pt.stackoverflow.com/a/229853/59479
 */
public class Teste {

  public static void main(String[] args) {
    String json = "[{\"codigo\": 1, \"nome\": \"José\", \"aprovado\": false}, {\"codigo\": 2, \"nome\": \"João\", \"aprovado\": true}]";
    List<String> campos = new LinkedList<>();

    campos.add("codigo");
    campos.add("nome");

    JSON2XLS.transformar(new JSONArray(json), "C:/D/teste/teste.xlsx");
    JSON2XLS.transformar(json, "C:/D/teste/teste2.xlsx");
    JSON2XLS.transformar(campos, new JSONArray(json), "C:/D/teste/teste3.xlsx");
    JSON2XLS.transformar(campos, json, "C:/D/teste/teste4.xlsx");
  }
}
