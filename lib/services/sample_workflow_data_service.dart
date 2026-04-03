import 'package:icare/models/consultation.dart';
import 'package:icare/models/lab_test_request.dart';
import 'package:icare/models/prescription.dart';
import 'package:icare/models/health_program_assignment.dart';
import 'package:icare/models/referral.dart';

/// Sample Workflow Data Service
///
/// Generates interconnected sample data demonstrating the connected virtual hospital
/// Shows how consultations trigger lab tests, prescriptions, health programs, and referrals
class SampleWorkflowDataService {
  static final SampleWorkflowDataService _instance = SampleWorkflowDataService._internal();
  factory SampleWorkflowDataService() => _instance;
  SampleWorkflowDataService._internal();

  /// Generate sample consultations with complete workflow
  List<Consultation> generateSampleConsultations() {
    return [
      // Consultation 1: Diabetes patient
      Consultation(
        id: 'consultation_001',
        patientId: 'patient_001',
        doctorId: 'doctor_002',
        appointmentId: 'appointment_001',
        consultationType: ConsultationType.followUp,
        status: ConsultationStatus.completed,
        history: PatientHistory(
          chiefComplaint: 'Follow-up for diabetes management',
          historyOfPresentIllness: 'Patient reports increased thirst and frequent urination over the past 2 weeks. Blood sugar readings at home have been elevated (180-220 mg/dL).',
          pastMedicalHistory: 'Type 2 Diabetes (diagnosed 2018), Hypertension',
          currentMedications: 'Metformin 500mg twice daily, Lisinopril 10mg once daily',
          allergies: 'Penicillin',
          familyHistory: 'Father had Type 2 Diabetes, Mother had hypertension',
          socialHistory: 'Non-smoker, occasional alcohol use',
        ),
        examination: PhysicalExamination(
          vitalSigns: VitalSigns(
            bloodPressure: '138/88',
            heartRate: 78,
            temperature: 98.2,
            respiratoryRate: 16,
            oxygenSaturation: 98,
            weight: 185.5,
            height: 70.0,
            bmi: 26.6,
          ),
          physicalExamFindings: 'Alert and oriented. No acute distress. Cardiovascular: Regular rate and rhythm. Respiratory: Clear to auscultation bilaterally. Abdomen: Soft, non-tender. Extremities: No edema.',
        ),
        diagnosis: Diagnosis(
          primaryDiagnosis: 'Type 2 Diabetes Mellitus, uncontrolled',
          icdCode: 'E11.65',
          differentialDiagnosis: 'Medication non-compliance, dietary indiscretion',
          clinicalNotes: 'Patient\'s diabetes is poorly controlled. HbA1c likely elevated. Need to adjust medication and reinforce lifestyle modifications.',
        ),
        treatmentPlan: TreatmentPlan(
          prescriptions: ['prescription_001'],
          labTests: ['lab_request_001'],
          healthProgramIds: ['program_001'],
          followUpInstructions: 'Follow up in 2 weeks to review lab results and adjust medications as needed. Continue home blood sugar monitoring.',
          referralId: null,
        ),
        startTime: DateTime.now().subtract(const Duration(days: 5)),
        endTime: DateTime.now().subtract(const Duration(days: 5, hours: -1)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      // Consultation 2: Hypertension patient
      Consultation(
        id: 'consultation_002',
        patientId: 'patient_002',
        doctorId: 'doctor_002',
        appointmentId: 'appointment_002',
        consultationType: ConsultationType.initial,
        status: ConsultationStatus.completed,
        history: PatientHistory(
          chiefComplaint: 'Headaches and dizziness',
          historyOfPresentIllness: 'Patient reports persistent headaches for the past month, worse in the morning. Occasional dizziness when standing up quickly.',
          pastMedicalHistory: 'No significant past medical history',
          currentMedications: 'None',
          allergies: 'No known drug allergies',
          familyHistory: 'Mother has hypertension, Father had stroke at age 65',
          socialHistory: 'Non-smoker, moderate alcohol use (2-3 drinks/week)',
        ),
        examination: PhysicalExamination(
          vitalSigns: VitalSigns(
            bloodPressure: '158/96',
            heartRate: 82,
            temperature: 98.6,
            respiratoryRate: 14,
            oxygenSaturation: 99,
            weight: 165.0,
            height: 66.0,
            bmi: 26.6,
          ),
          physicalExamFindings: 'Alert and oriented. Cardiovascular: Regular rate and rhythm, no murmurs. Neurological exam normal. Fundoscopic exam shows mild arterial narrowing.',
        ),
        diagnosis: Diagnosis(
          primaryDiagnosis: 'Essential Hypertension',
          icdCode: 'I10',
          differentialDiagnosis: 'Secondary hypertension, white coat hypertension',
          clinicalNotes: 'New diagnosis of hypertension. Will start medication and lifestyle modifications. Need baseline labs.',
        ),
        treatmentPlan: TreatmentPlan(
          prescriptions: ['prescription_002'],
          labTests: ['lab_request_002'],
          healthProgramIds: ['program_002'],
          followUpInstructions: 'Follow up in 4 weeks to assess blood pressure control. Home BP monitoring recommended.',
          referralId: null,
        ),
        startTime: DateTime.now().subtract(const Duration(days: 3)),
        endTime: DateTime.now().subtract(const Duration(days: 3, hours: -1)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      // Consultation 3: Chest pain - needs cardiology referral
      Consultation(
        id: 'consultation_003',
        patientId: 'patient_003',
        doctorId: 'doctor_002',
        appointmentId: 'appointment_003',
        consultationType: ConsultationType.urgent,
        status: ConsultationStatus.completed,
        history: PatientHistory(
          chiefComplaint: 'Chest pain with exertion',
          historyOfPresentIllness: 'Patient reports substernal chest pressure occurring with physical activity over the past week. Pain radiates to left arm, resolves with rest after 5-10 minutes.',
          pastMedicalHistory: 'Hyperlipidemia, Type 2 Diabetes',
          currentMedications: 'Atorvastatin 20mg daily, Metformin 1000mg twice daily',
          allergies: 'No known drug allergies',
          familyHistory: 'Father had MI at age 58',
          socialHistory: 'Former smoker (quit 5 years ago), no alcohol',
        ),
        examination: PhysicalExamination(
          vitalSigns: VitalSigns(
            bloodPressure: '142/88',
            heartRate: 76,
            temperature: 98.4,
            respiratoryRate: 16,
            oxygenSaturation: 97,
            weight: 195.0,
            height: 69.0,
            bmi: 28.8,
          ),
          physicalExamFindings: 'Alert, no acute distress at rest. Cardiovascular: Regular rate and rhythm, no murmurs. Respiratory: Clear bilaterally. No peripheral edema.',
        ),
        diagnosis: Diagnosis(
          primaryDiagnosis: 'Angina Pectoris, suspected',
          icdCode: 'I20.9',
          differentialDiagnosis: 'Coronary artery disease, unstable angina',
          clinicalNotes: 'Concerning symptoms for cardiac ischemia. Multiple risk factors present. Urgent cardiology evaluation needed.',
        ),
        treatmentPlan: TreatmentPlan(
          prescriptions: ['prescription_003'],
          labTests: ['lab_request_003'],
          healthProgramIds: ['program_003'],
          followUpInstructions: 'Urgent cardiology referral. Patient instructed to go to ER if chest pain worsens or occurs at rest.',
          referralId: 'referral_001',
        ),
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 2, hours: -1)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      // Consultation 4: Anxiety disorder
      Consultation(
        id: 'consultation_004',
        patientId: 'patient_004',
        doctorId: 'doctor_008',
        appointmentId: 'appointment_004',
        consultationType: ConsultationType.initial,
        status: ConsultationStatus.completed,
        history: PatientHistory(
          chiefComplaint: 'Anxiety and panic attacks',
          historyOfPresentIllness: 'Patient reports increasing anxiety over the past 3 months. Experiencing panic attacks 2-3 times per week with palpitations, sweating, and fear of losing control.',
          pastMedicalHistory: 'No significant medical history',
          currentMedications: 'None',
          allergies: 'No known drug allergies',
          familyHistory: 'Mother has depression',
          socialHistory: 'Non-smoker, no alcohol or drug use. Works as accountant, reports high job stress.',
        ),
        examination: PhysicalExamination(
          vitalSigns: VitalSigns(
            bloodPressure: '128/78',
            heartRate: 88,
            temperature: 98.6,
            respiratoryRate: 18,
            oxygenSaturation: 99,
            weight: 135.0,
            height: 64.0,
            bmi: 23.2,
          ),
          physicalExamFindings: 'Alert, appears anxious. Cardiovascular and respiratory exams normal. No focal neurological deficits.',
        ),
        diagnosis: Diagnosis(
          primaryDiagnosis: 'Generalized Anxiety Disorder',
          icdCode: 'F41.1',
          differentialDiagnosis: 'Panic disorder, adjustment disorder',
          clinicalNotes: 'Meets criteria for GAD. Will start SSRI and recommend therapy. Health program for stress management.',
        ),
        treatmentPlan: TreatmentPlan(
          prescriptions: ['prescription_004'],
          labTests: [],
          healthProgramIds: ['program_005'],
          followUpInstructions: 'Follow up in 2 weeks to assess medication response. Consider referral to therapist.',
          referralId: null,
        ),
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().subtract(const Duration(days: 1, hours: -1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      // Consultation 5: Prenatal care
      Consultation(
        id: 'consultation_005',
        patientId: 'patient_006',
        doctorId: 'doctor_009',
        appointmentId: 'appointment_005',
        consultationType: ConsultationType.followUp,
        status: ConsultationStatus.completed,
        history: PatientHistory(
          chiefComplaint: 'Prenatal visit - 12 weeks pregnant',
          historyOfPresentIllness: 'First pregnancy, 12 weeks gestation. Mild nausea improving. No vaginal bleeding or abdominal pain.',
          pastMedicalHistory: 'No significant medical history',
          currentMedications: 'Prenatal vitamins',
          allergies: 'No known drug allergies',
          familyHistory: 'No significant family history',
          socialHistory: 'Non-smoker, no alcohol or drug use',
        ),
        examination: PhysicalExamination(
          vitalSigns: VitalSigns(
            bloodPressure: '118/72',
            heartRate: 76,
            temperature: 98.4,
            respiratoryRate: 14,
            oxygenSaturation: 99,
            weight: 142.0,
            height: 65.0,
            bmi: 23.6,
          ),
          physicalExamFindings: 'Alert and oriented. Abdomen: Gravid uterus palpable. Fetal heart tones detected at 150 bpm. No edema.',
        ),
        diagnosis: Diagnosis(
          primaryDiagnosis: 'Normal pregnancy, first trimester',
          icdCode: 'Z34.00',
          differentialDiagnosis: '',
          clinicalNotes: 'Uncomplicated pregnancy at 12 weeks. Will order routine prenatal labs and ultrasound.',
        ),
        treatmentPlan: TreatmentPlan(
          prescriptions: [],
          labTests: ['lab_request_004'],
          healthProgramIds: ['program_007'],
          followUpInstructions: 'Next prenatal visit in 4 weeks. Continue prenatal vitamins. Ultrasound scheduled.',
          referralId: null,
        ),
        startTime: DateTime.now().subtract(const Duration(hours: 6)),
        endTime: DateTime.now().subtract(const Duration(hours: 5)),
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  /// Generate sample lab test requests
  List<LabTestRequest> generateSampleLabRequests() {
    return [
      LabTestRequest(
        id: 'lab_request_001',
        consultationId: 'consultation_001',
        patientId: 'patient_001',
        doctorId: 'doctor_002',
        testName: 'HbA1c and Comprehensive Metabolic Panel',
        testType: 'Blood Test',
        priority: LabTestPriority.normal,
        status: LabTestStatus.pending,
        clinicalIndication: 'Type 2 Diabetes Mellitus, uncontrolled',
        doctorNotes: 'Patient has elevated home blood sugar readings. Need HbA1c to assess long-term control and CMP to check kidney function.',
        requestedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LabTestRequest(
        id: 'lab_request_002',
        consultationId: 'consultation_002',
        patientId: 'patient_002',
        doctorId: 'doctor_002',
        testName: 'Complete Blood Count and Basic Metabolic Panel',
        testType: 'Blood Test',
        priority: LabTestPriority.normal,
        status: LabTestStatus.accepted,
        clinicalIndication: 'Essential Hypertension, newly diagnosed',
        doctorNotes: 'Baseline labs for new hypertension diagnosis. Check for secondary causes.',
        requestedAt: DateTime.now().subtract(const Duration(days: 3)),
        acceptedAt: DateTime.now().subtract(const Duration(days: 2)),
        labId: 'lab_001',
      ),
      LabTestRequest(
        id: 'lab_request_003',
        consultationId: 'consultation_003',
        patientId: 'patient_003',
        doctorId: 'doctor_002',
        testName: 'Troponin, ECG, and Lipid Panel',
        testType: 'Cardiac Panel',
        priority: LabTestPriority.urgent,
        status: LabTestStatus.inProgress,
        clinicalIndication: 'Angina Pectoris, suspected coronary artery disease',
        doctorNotes: 'Urgent cardiac workup for chest pain with exertion. Rule out acute coronary syndrome.',
        requestedAt: DateTime.now().subtract(const Duration(days: 2)),
        acceptedAt: DateTime.now().subtract(const Duration(days: 2, hours: -2)),
        labId: 'lab_003',
      ),
      LabTestRequest(
        id: 'lab_request_004',
        consultationId: 'consultation_005',
        patientId: 'patient_006',
        doctorId: 'doctor_009',
        testName: 'Prenatal Panel (CBC, Blood Type, Rubella, HIV, Hepatitis)',
        testType: 'Prenatal Screening',
        priority: LabTestPriority.routine,
        status: LabTestStatus.pending,
        clinicalIndication: 'Normal pregnancy, first trimester',
        doctorNotes: 'Routine prenatal labs at 12 weeks gestation.',
        requestedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  /// Generate sample prescriptions
  List<Prescription> generateSamplePrescriptions() {
    return [
      Prescription(
        id: 'prescription_001',
        consultationId: 'consultation_001',
        patientId: 'patient_001',
        doctorId: 'doctor_002',
        medicines: [
          PrescriptionMedicine(
            medicineName: 'Metformin',
            dosage: '1000mg',
            frequency: 'Twice daily',
            duration: '30 days',
            instructions: 'Take with meals',
          ),
          PrescriptionMedicine(
            medicineName: 'Glipizide',
            dosage: '5mg',
            frequency: 'Once daily',
            duration: '30 days',
            instructions: 'Take 30 minutes before breakfast',
          ),
        ],
        doctorNotes: 'Increased Metformin dose and added Glipizide for better glycemic control.',
        status: PrescriptionStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Prescription(
        id: 'prescription_002',
        consultationId: 'consultation_002',
        patientId: 'patient_002',
        doctorId: 'doctor_002',
        medicines: [
          PrescriptionMedicine(
            medicineName: 'Lisinopril',
            dosage: '10mg',
            frequency: 'Once daily',
            duration: '30 days',
            instructions: 'Take in the morning',
          ),
        ],
        doctorNotes: 'Starting ACE inhibitor for blood pressure control.',
        status: PrescriptionStatus.sentToPharmacy,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        pharmacyId: 'pharmacy_001',
      ),
      Prescription(
        id: 'prescription_003',
        consultationId: 'consultation_003',
        patientId: 'patient_003',
        doctorId: 'doctor_002',
        medicines: [
          PrescriptionMedicine(
            medicineName: 'Aspirin',
            dosage: '81mg',
            frequency: 'Once daily',
            duration: '90 days',
            instructions: 'Take with food',
          ),
          PrescriptionMedicine(
            medicineName: 'Nitroglycerin',
            dosage: '0.4mg',
            frequency: 'As needed',
            duration: '30 tablets',
            instructions: 'Sublingual for chest pain. If pain persists after 3 doses (5 min apart), call 911',
          ),
        ],
        doctorNotes: 'Antiplatelet therapy and sublingual nitro for angina symptoms pending cardiology evaluation.',
        status: PrescriptionStatus.preparing,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        pharmacyId: 'pharmacy_002',
      ),
      Prescription(
        id: 'prescription_004',
        consultationId: 'consultation_004',
        patientId: 'patient_004',
        doctorId: 'doctor_008',
        medicines: [
          PrescriptionMedicine(
            medicineName: 'Sertraline',
            dosage: '50mg',
            frequency: 'Once daily',
            duration: '30 days',
            instructions: 'Take in the morning with food',
          ),
        ],
        doctorNotes: 'Starting SSRI for generalized anxiety disorder. May take 4-6 weeks for full effect.',
        status: PrescriptionStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  /// Generate sample health program assignments
  List<HealthProgramAssignment> generateSampleProgramAssignments() {
    return [
      HealthProgramAssignment(
        id: 'assignment_001',
        patientId: 'patient_001',
        doctorId: 'doctor_002',
        programId: 'program_001',
        programName: 'Diabetes Management Program',
        status: HealthProgramAssignmentStatus.inProgress,
        reasonForAssignment: 'Patient has uncontrolled Type 2 Diabetes. This program will help with lifestyle modifications and medication adherence.',
        assignedAt: DateTime.now().subtract(const Duration(days: 5)),
        totalModules: 3,
        completedModules: 1,
        progressPercentage: 33.3,
      ),
      HealthProgramAssignment(
        id: 'assignment_002',
        patientId: 'patient_002',
        doctorId: 'doctor_002',
        programId: 'program_002',
        programName: 'Hypertension Control Program',
        status: HealthProgramAssignmentStatus.assigned,
        reasonForAssignment: 'Newly diagnosed hypertension. Program covers DASH diet and lifestyle modifications.',
        assignedAt: DateTime.now().subtract(const Duration(days: 3)),
        totalModules: 2,
        completedModules: 0,
        progressPercentage: 0,
      ),
      HealthProgramAssignment(
        id: 'assignment_003',
        patientId: 'patient_003',
        doctorId: 'doctor_002',
        programId: 'program_003',
        programName: 'Heart Health & Prevention',
        status: HealthProgramAssignmentStatus.assigned,
        reasonForAssignment: 'Patient has multiple cardiac risk factors and suspected angina. This program will help with risk reduction.',
        assignedAt: DateTime.now().subtract(const Duration(days: 2)),
        totalModules: 1,
        completedModules: 0,
        progressPercentage: 0,
      ),
      HealthProgramAssignment(
        id: 'assignment_004',
        patientId: 'patient_004',
        doctorId: 'doctor_008',
        programId: 'program_005',
        programName: 'Stress & Anxiety Management',
        status: HealthProgramAssignmentStatus.assigned,
        reasonForAssignment: 'Patient diagnosed with generalized anxiety disorder. Program teaches coping strategies and relaxation techniques.',
        assignedAt: DateTime.now().subtract(const Duration(days: 1)),
        totalModules: 2,
        completedModules: 0,
        progressPercentage: 0,
      ),
      HealthProgramAssignment(
        id: 'assignment_005',
        patientId: 'patient_006',
        doctorId: 'doctor_009',
        programId: 'program_007',
        programName: 'Prenatal Care & Wellness',
        status: HealthProgramAssignmentStatus.assigned,
        reasonForAssignment: 'First pregnancy at 12 weeks. Program provides education on prenatal care and preparation for childbirth.',
        assignedAt: DateTime.now().subtract(const Duration(hours: 6)),
        totalModules: 1,
        completedModules: 0,
        progressPercentage: 0,
      ),
    ];
  }

  /// Generate sample referrals
  List<Referral> generateSampleReferrals() {
    return [
      Referral(
        id: 'referral_001',
        patientId: 'patient_003',
        referringDoctorId: 'doctor_002',
        specialtyRequired: 'Cardiology',
        urgency: 'urgent',
        reasonForReferral: 'Suspected coronary artery disease',
        clinicalSummary: 'Patient presents with exertional chest pain radiating to left arm. Multiple cardiac risk factors including diabetes, hyperlipidemia, and family history of early MI. ECG shows possible ischemic changes. Urgent cardiology evaluation needed for stress test and possible cardiac catheterization.',
        status: ReferralStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
