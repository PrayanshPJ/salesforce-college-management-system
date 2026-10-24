@IsTest
private class EnrollmentTriggerHandlerTest {

    @IsTest
    static void testDuplicateEnrollmentBlocked() {
        Student__c student = new Student__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Student',
            Mobile__c = '9876543210',
            Email__c = 'test.student@example.com',
            Status__c = 'Active'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Test Course',
            Course_Code__c = 'TEST-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Test Subject',
            Subject_Code__c = 'TEST101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Active',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c firstEnrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );
        insert firstEnrollment;

        Enrollment__c duplicateEnrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );

        Test.startTest();
        Database.SaveResult result =
            Database.insert(duplicateEnrollment, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'Duplicate enrollment should be blocked.'
        );
    }

    @IsTest
    static void testValidEnrollmentUpdate() {
        Student__c student = new Student__c(
            First_Name__c = 'Update',
            Last_Name__c = 'Test',
            Mobile__c = '9876543211',
            Email__c = 'update.test@example.com',
            Status__c = 'Active'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Update Test Course',
            Course_Code__c = 'UPD-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Update Test Subject',
            Subject_Code__c = 'UPD101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Active',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );
        insert enrollment;

        Test.startTest();
        enrollment.Status__c = 'Completed';
        update enrollment;
        Test.stopTest();

        Enrollment__c updatedEnrollment = [
            SELECT Status__c
            FROM Enrollment__c
            WHERE Id = :enrollment.Id
        ];

        System.assertEquals(
            'Completed',
            updatedEnrollment.Status__c,
            'The valid enrollment update should succeed.'
        );
    }

    @IsTest
    static void testDuplicateEnrollmentUpdateBlocked() {
        Student__c student1 = new Student__c(
            First_Name__c = 'Update',
            Last_Name__c = 'One',
            Mobile__c = '9876543212',
            Email__c = 'update.one@example.com',
            Status__c = 'Active'
        );
        Student__c student2 = new Student__c(
            First_Name__c = 'Update',
            Last_Name__c = 'Two',
            Mobile__c = '9876543213',
            Email__c = 'update.two@example.com',
            Status__c = 'Active'
        );
        insert new List<Student__c>{ student1, student2 };

        Course__c course = new Course__c(
            Name = 'Duplicate Test Course',
            Course_Code__c = 'DUP-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Duplicate Test Subject',
            Subject_Code__c = 'DUP101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Active',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c existingEnrollment = new Enrollment__c(
            Student__c = student1.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );
        Enrollment__c enrollmentToUpdate = new Enrollment__c(
            Student__c = student2.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );
        insert new List<Enrollment__c>{
            existingEnrollment, enrollmentToUpdate
        };

        enrollmentToUpdate.Student__c = student1.Id;

        Test.startTest();
        Database.SaveResult result =
            Database.update(enrollmentToUpdate, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'An update creating a duplicate enrollment should be blocked.'
        );
    }

    @IsTest
    static void testInactiveStudentEnrollmentBlocked() {
        Student__c student = new Student__c(
            First_Name__c = 'Inactive',
            Last_Name__c = 'Student',
            Mobile__c = '9876543214',
            Email__c = 'inactive.student@example.com',
            Status__c = 'Graduated'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Inactive Test Course',
            Course_Code__c = 'INA-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Inactive Test Subject',
            Subject_Code__c = 'INA101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Active',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );

        Test.startTest();
        Database.SaveResult result =
            Database.insert(enrollment, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'Enrollment for a graduated student should be blocked.'
        );
    }

    @IsTest
    static void testInactiveSubjectEnrollmentBlocked() {
        Student__c student = new Student__c(
            First_Name__c = 'Subject',
            Last_Name__c = 'Test',
            Mobile__c = '9876543215',
            Email__c = 'subject.test@example.com',
            Status__c = 'Active'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Inactive Subject Course',
            Course_Code__c = 'INS-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Inactive Subject',
            Subject_Code__c = 'INS101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Inactive',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );

        Test.startTest();
        Database.SaveResult result =
            Database.insert(enrollment, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'Enrollment for an inactive subject should be blocked.'
        );
    }

    @IsTest
    static void testValidEnrollmentInsert() {
        Student__c student = new Student__c(
            First_Name__c = 'Valid',
            Last_Name__c = 'Student',
            Mobile__c = '9876543216',
            Email__c = 'valid.student@example.com',
            Status__c = 'Active'
        );
        insert student;

        Course__c course = new Course__c(
            Name = 'Valid Course',
            Course_Code__c = 'VAL-CSE',
            Duration__c = 4,
            Department__c = 'CSE',
            Intake_Capacity__c = 30
        );
        insert course;

        Subject__c subject = new Subject__c(
            Name = 'Valid Subject',
            Subject_Code__c = 'VAL101',
            Semester__c = 1,
            Credits__c = 3,
            Course__c = course.Id,
            Status__c = 'Active',
            Subject_Type__c = 'Core'
        );
        insert subject;

        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Subject__c = subject.Id,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );

        Test.startTest();
        insert enrollment;
        Test.stopTest();

        System.assertNotEquals(
            null,
            enrollment.Id,
            'A valid enrollment should be inserted successfully.'
        );
    }





}
