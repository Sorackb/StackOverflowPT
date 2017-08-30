package org.lucassouza.jsopt.requisicaohttp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

/**
 *
 * @author Lucas
 */
public class RequisicaoHTTP {

  private String resultado;
  private JSONObject js_object;
  private JSONObject obj_kappauni1;

  public static void main(String[] args) {
    RequisicaoHTTP req = new RequisicaoHTTP();

    try {
      req.conectar();
    } catch (IOException ex) {
      Logger.getLogger(RequisicaoHTTP.class.getName()).log(Level.SEVERE, null, ex);
    }
  }

  void conectar() throws IOException {
    final String ENDERECO = "http://dwarfpool.com/eth/api?wallet=0940f5fAEF2bba7e1e6288E4bc4E9c75ee334b97";
    //Passo por parametro o endereco no qual deve pegar o json
    URL url = new URL(ENDERECO);
    //Abro conexão usando a url do json, assim vai ser conectado
    URLConnection conexao = url.openConnection();
    //Ler valores da api
    InputStreamReader inStreamread = new InputStreamReader(conexao.getInputStream());
    //Guardar valores api em buffer
    BufferedReader buffread = new BufferedReader(inStreamread);
    //String que vai receber os valores gravados no buffer
    this.resultado = "";

    String linha;

    while ((linha = buffread.readLine()) != null) {
      //Imprime o resultado
      this.resultado += linha + System.lineSeparator();
    }

    System.out.println(this.resultado);
    this.js_object = new JSONObject(this.resultado);
    //obj_kappauni1 = js_object.getJSONObject("kappauni1");
    // boolean alive = js_object.getBoolean("alive");
    //  System.out.println(alive);

    //Fecho gravação
    inStreamread.close();
    buffread.close();

  }
}
