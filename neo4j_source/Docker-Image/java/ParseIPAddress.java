
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;

public class ParseIPAddress {
	
	public static void main(String[] args){
		BufferedReader reader = null;
		try {
			if (args.length != 4){
				return;
			}
			String serviceName = args[0];
			String param = args[1];
			int clusterSize = Integer.parseInt(args[2]);
			String presentName = args[3];
			StringBuffer ips = new StringBuffer();
			for (int i = 0; i < clusterSize; i ++){
				String domain = presentName + "-" + i + "." + serviceName + ".default.svc.cluster.local";
				InetAddress address = InetAddress.getByName(domain);
				if (address != null){
					ips.append(address.getHostAddress() + ":5000,");
				}
				System.out.println(domain + ": " + address.getHostAddress());
			}
			String res = ips.substring(0, ips.length() - 1);
			String cmd = "/var/lib/neo4j/java/run.sh " + res + " " + param;
                        System.out.println(cmd);
			Process ps = Runtime.getRuntime().exec(cmd);
			reader = new BufferedReader(new InputStreamReader(ps.getInputStream()));
			String line = reader.readLine();
			while(line != null){
                                System.out.println(line);
				line = reader.readLine();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if (reader != null){
				try {
					reader.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}

