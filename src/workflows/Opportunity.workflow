<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_invitation_details_to_SMS_system</fullName>
        <ccEmails>prasanthn@flipkart.com</ccEmails>
        <ccEmails>murali.dharnala@in.pwc.com</ccEmails>
        <description>Send invitation details to SMS system</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Invitation_to_SMS</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Stage_to_Registered</fullName>
        <field>StageName</field>
        <literalValue>Pending min SKU creation</literalValue>
        <name>Change Stage to Pending min SKU creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_SS_Drop</fullName>
        <description>Uncheck SS Drop</description>
        <field>SS_Drop__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck SS Drop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeToOnboarding</fullName>
        <field>RecordTypeId</field>
        <lookupValue>InOnboarding</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateRecordTypeToOnboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AlertOnScreeningFailure</fullName>
        <actions>
            <name>Screening_Failed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SS_Screening__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change opportunity stage as %22Pending min SKU creation%22%2C if %22RedirectState%22 is 5</fullName>
        <actions>
            <name>Change_Stage_to_Registered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Redirect_State__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <description>Change opportunity stage as &quot;Pending min SKU creation&quot;, if &quot;RedirectState&quot; is 5 -  CSV Upload Processing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChangeRecordTypeWhenStageChanges</fullName>
        <actions>
            <name>UpdateRecordTypeToOnboarding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change record type of Opportunity to InOnboarding when stage changes appropriately</description>
        <formula>NOT(OR((ISPICKVAL(StageName, &apos;Candidate&apos;)),     (ISPICKVAL(StageName, &apos;Ready to Onboard&apos;))  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification to BD when Opportunity Dropped by SS</fullName>
        <actions>
            <name>Opportunity_Dropped_by_SS</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SS_Drop__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notification to BD when Opportunity Dropped by SS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Invitation To SMS</fullName>
        <actions>
            <name>Send_invitation_details_to_SMS_system</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Is_Invited__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>Send Invitation To SMS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck SS Drop on Revisit Date</fullName>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.BD_Action__c</field>
            <operation>equals</operation>
            <value>Continue</value>
        </criteriaItems>
        <description>Uncheck SS Drop on Revisit Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Uncheck_SS_Drop</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Opportunity_Dropped_by_SS</fullName>
        <assignedToType>owner</assignedToType>
        <description>Opportunity has been dropped by SS Agent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Opportunity Dropped by SS</subject>
    </tasks>
    <tasks>
        <fullName>Screening_Failed</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity cannot be Invited now as it has failed SS checks.
FYI.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Screening Failed</subject>
    </tasks>
</Workflow>
