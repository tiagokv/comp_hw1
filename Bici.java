public class Bici {

    // the Bicycle class has
    // three fields
    public int cadence;
    public int gear;
    public int speed;
    public String name;

    /* the Bicycle class has
     one constructor */
    public Bici(int startCadence, int startSpeed, int startGear, String startName) {
        gear = startGear;
        cadence = startCadence;
        speed = startSpeed;
        name = startName;
    }

    /* the Bicycle class has
     four methods
     */

    /*public void setCadence(int newValue) {
        cadence = newValue;
    }

    public void setGear(int newValue) {
        gear = newValue;
    }

    public void applyBrake(int decrement) {
        speed -= decrement;
    }*/

    public void speedUp(int increment) {
        speed += increment;
    }

    public String getName(){
      return name;
    }

    private void setName(String name){
      this.name = name;
    }

    /*

    public void forgetToUncomment(int nothing){
      nothing++;
    }
    */

}
