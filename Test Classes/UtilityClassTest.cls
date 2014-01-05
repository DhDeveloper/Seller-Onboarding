@isTest
public class UtilityClassTest {
	static testmethod void testDatesMethod(){
		List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
		Date oDate = UtilityClass.addDaysExcludingSundaysHolidays(date.parse('09/01/2014'), 5, holidaysList);
		System.debug('Output Date: '+oDate);
	}
}