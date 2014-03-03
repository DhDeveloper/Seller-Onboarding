<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BGM_Email_Alert_For_Lead_Approval</fullName>
        <description>BGM Email Alert For Lead Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>BGM_Senior_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_New_Lead_Requires_Approval</template>
    </alerts>
    <alerts>
        <fullName>CCC_Email_Alert_For_Lead_Approval</fullName>
        <description>CCC_Email Alert For Lead Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>CCC_Senior_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_New_Lead_Requires_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_For_Lead_Approval</fullName>
        <description>Email Alert For Lead Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>BGM_Senior_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_New_Lead_Requires_Approval</template>
    </alerts>
    <alerts>
        <fullName>Lead_Assignment</fullName>
        <description>Lead Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Lead_Parked_and_tomorrow_is_last_day_to_revisit</fullName>
        <description>Lead Parked and tomorrow is last day to revisit</description>
        <protected>false</protected>
        <recipients>
            <recipient>BGM_Senior_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Parked_notification</template>
    </alerts>
    <alerts>
        <fullName>Lead_has_been_approved</fullName>
        <description>Lead has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_Lead_Approved_By_Approver</template>
    </alerts>
    <alerts>
        <fullName>On_Approve</fullName>
        <description>On Approve</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_Lead_Approved_By_Approver</template>
    </alerts>
    <alerts>
        <fullName>On_Approve_Lead</fullName>
        <description>On Approve Lead</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_Lead_Approved_By_Approver</template>
    </alerts>
    <alerts>
        <fullName>Softlines_Email_Alert_For_Lead_Approval</fullName>
        <description>Softlines_Email Alert For Lead Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>Softlines_Senior_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Seller_On_boarding_New_Lead_Requires_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChangRecordTypeToEvalAction</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Evaluation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ChangeRecordTypeToEval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeLeadStatusToInEval</fullName>
        <field>Status</field>
        <literalValue>In Evaluation</literalValue>
        <name>ChangeLeadStatusToInEval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Lead_Status_Parked</fullName>
        <description>Change Lead Status Parked</description>
        <field>Status</field>
        <literalValue>Parked</literalValue>
        <name>Change Lead Status Parked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Drop_Lead</fullName>
        <description>Drop Lead</description>
        <field>Status</field>
        <literalValue>Dropped</literalValue>
        <name>Drop Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Reject_Drop_Lead</fullName>
        <field>Status</field>
        <literalValue>Dropped</literalValue>
        <name>On Reject Drop Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pause_Lead</fullName>
        <description>Pause Lead</description>
        <field>Status</field>
        <literalValue>Parked</literalValue>
        <name>Pause Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatusToConverted</fullName>
        <field>Status</field>
        <literalValue>Converted</literalValue>
        <name>UpdateFieldStatusToConverted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approve_Status_to_2</fullName>
        <description>Update Approve Status to 2</description>
        <field>Approval_State__c</field>
        <formula>2</formula>
        <name>Update Approve Status to 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approve_Status_to_3</fullName>
        <description>Update Approve Status to 3</description>
        <field>Approval_State__c</field>
        <formula>3</formula>
        <name>Update Approve Status to 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approver_State_to_4</fullName>
        <description>Update Approver State to 4</description>
        <field>Approval_State__c</field>
        <formula>4</formula>
        <name>Update Approver State to 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approver_Status_to_5</fullName>
        <description>Update Approver Status to 5</description>
        <field>Approval_State__c</field>
        <formula>5</formula>
        <name>Update Approver Status to 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status_to_Dropped</fullName>
        <description>Update Lead Status to Dropped</description>
        <field>Status</field>
        <literalValue>Dropped</literalValue>
        <name>Update Lead Status to Dropped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BGM Lead Submitted For Approval</fullName>
        <actions>
            <name>Email_Alert_For_Lead_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approval_State__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SuperCategory__c</field>
            <operation>equals</operation>
            <value>BGM</value>
        </criteriaItems>
        <description>BGM Lead Submitted For Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CCC Lead Assignment to User</fullName>
        <actions>
            <name>Lead_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>BGM UnAssigned,CCC UnAssigned,Softlines UnAssigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SuperCategory__c</field>
            <operation>equals</operation>
            <value>CCC</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CCC Lead Submitted For Approval</fullName>
        <actions>
            <name>CCC_Email_Alert_For_Lead_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approval_State__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SuperCategory__c</field>
            <operation>equals</operation>
            <value>CCC</value>
        </criteriaItems>
        <description>CCC Lead Submitted For Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChangeRecordTypeToEval</fullName>
        <actions>
            <name>ChangRecordTypeToEvalAction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>In Evaluation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Approved</fullName>
        <actions>
            <name>Lead_has_been_approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Approve_Status_to_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approver_Action__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Lead Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Dropped</fullName>
        <actions>
            <name>Update_Approver_State_to_4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Status_to_Dropped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approver_Action__c</field>
            <operation>equals</operation>
            <value>Dropped</value>
        </criteriaItems>
        <description>Lead Dropped</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Parked</fullName>
        <actions>
            <name>Change_Lead_Status_Parked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Approver_Status_to_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approver_Action__c</field>
            <operation>equals</operation>
            <value>Parked</value>
        </criteriaItems>
        <description>Lead Parked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Resubmitted</fullName>
        <actions>
            <name>Update_Approve_Status_to_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approver_Action__c</field>
            <operation>equals</operation>
            <value>Resubmit</value>
        </criteriaItems>
        <description>Lead Resubmitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Submitted For Approval</fullName>
        <actions>
            <name>Email_Alert_For_Lead_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Approval_State__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Lead Submitted For Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify and alert users when leads are parked</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Parked</value>
        </criteriaItems>
        <description>Notify and alert users when leads are parked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lead_Parked_and_tomorrow_is_last_day_to_revisit</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Lead_is_Parked</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Lead.RevisitAfterDate__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Softline Lead Submitted For Approval</fullName>
        <actions>
            <name>Softlines_Email_Alert_For_Lead_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approval_State__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SuperCategory__c</field>
            <operation>equals</operation>
            <value>Softlines</value>
        </criteriaItems>
        <description>Softline Lead Submitted For Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Lead_is_Parked</fullName>
        <assignedTo>BGM_Senior_Manager</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Lead has been parked. Before tomorrow you need to update status</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead is Parked</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task</fullName>
        <assignedTo>prasanthn+pwc@flipkart.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Test Task</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task2</fullName>
        <assignedTo>prasanthn+pwc@flipkart.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Test Task2</subject>
    </tasks>
</Workflow>
