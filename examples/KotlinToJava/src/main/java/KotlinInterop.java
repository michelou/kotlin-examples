import kotlin.Unit;

public class KotlinInterop {

    private static void log(String msg) {
        System.out.println("[java] " + msg);
    }

    public static void main(String args[]) {
        // Lambda arguments
        Greeter greeter = new Greeter();
        greeter.sayHi(name -> {
            log("Hello, " + name + "!");
            return Unit.INSTANCE;
        });
        
        // Companion functions
        KotlinClass.doWork();
    }    
}
