/**
  * This Apex Class contains common methods used across application
**/
public class UtilityClass{
    
    /**
	  * This method add days to input date excluding Sundays and organization holidays
	  * @Param iDate  -- input Date
	  * @Param iDays  -- Days to be added to input Date
	  * @return oDate -- Final date after adding days excluding sundays & holidays 
	**/
    public static Date addDaysExcludingSundaysHolidays(Date iDate, Integer iDays, List<Holiday> holidaysList){
        Date oDate = iDate;
        
        for(Integer i=1; i <= iDays; i++){
        	oDate = oDate + 1;
        	
        	boolean hasSunday = false;
	        boolean hasHoliday = false;
	    
	        do{
	            hasSunday = UtilityClass.isSunday(oDate);
	            hasHoliday = UtilityClass.isHoliday(oDate,holidaysList);
	    
	            if(hasSunday == true){
	                oDate = oDate + 1;
	            }else if(hasHoliday == true){
	                oDate = oDate + 1;
	            }
	            System.debug(i+'iteration --> hasSunday: '+hasSunday+' - hasHoliday: '+hasHoliday+' - oDate Final: '+oDate);
	        }while(!(hasSunday == false) || !(hasHoliday == false));
        }
        
        return oDate;
    }
    
    /**
	  * This method returns input date is Sunday or not
	  * @Param iDate
	  * @return true/false 
	**/
    public static boolean isSunday(Date iDate){
        Integer daysBetween = iDate.toStartOfWeek().daysBetween(iDate);
        
        if(daysBetween == 6){
            return true;
        }else{
            return false;
        }
    }
    
    /**
	  * This method returns input date is Organization holiday or not
	  * @Param iDate
	  * @return true/false 
	**/
    public static boolean isHoliday(Date iDate,List<Holiday> holidaysList){
        Integer counter = 0;

        for(Holiday h:holidaysList){
            if(iDate.daysBetween(h.ActivityDate) == 0){
                counter++;
            }
        }
        
        if(counter > 0){
            return true;
        }else{
            return false;
        }
    }
    
    /**
      * This method calculate days between given start date and end date excluding Sundays and holidays
      * @Param startDate
      * @Param endDate
      * @Param holidaysList
      * @return integer
    **/
    public static Integer daysBetweenExcludingSundaysHolidays(Date startDate, Date endDate, List<Holiday> holidaysList){
        Integer totalDays = startDate.daysBetween(endDate);
        Integer holidays = 0;
        Integer daysBetween = 0;
        Date tempDate = startDate;
        for (Integer i=0; i<= totalDays;i++){
            if(isSunday(tempDate)){
                holidays++;
            }else if(isHoliday(tempDate,holidaysList)){
                holidays++;
            }
            tempDate = tempDate + 1;
        }
        if(totalDays >= holidays){
	        daysBetween = totalDays - holidays;
        }
        return daysBetween;
    }
}