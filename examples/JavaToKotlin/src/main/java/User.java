// For a method to be represented as a property in Kotlin, strict "bean"-style
// prefixing must be used.
public class User {
    private String name = "<name>";
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public boolean isActive() { /*..*/ return true; }
}
