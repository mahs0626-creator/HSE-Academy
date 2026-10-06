import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HSEAcademyApp());

class HSEAcademyApp extends StatelessWidget {
  const HSEAcademyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HSE Academy',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        home: const AuthPage(),
      );
}

class Lesson {
  final String id, title, summary, body;
  final List<Question> questions;
  const Lesson(this.id, this.title, this.summary, this.body, this.questions);
}

class Question {
  final String text;
  final List<String> options;
  final int answer;
  const Question(this.text, this.options, this.answer);
}

class Course {
  final String id, title, subtitle;
  final IconData icon;
  final List<Lesson> lessons;
  const Course(this.id, this.title, this.subtitle, this.icon, this.lessons);
}

const List<Lesson> oshaLessons = [
  Lesson('osha-1', 'What is OSHA?', 'Purpose, scope and role of OSHA',
      '''OSHA stands for the Occupational Safety and Health Administration. The central purpose of OSHA is to help assure safe and healthful working conditions for workers by setting and enforcing standards, providing training and assistance, and supporting workplace safety and health.''', [
    Question('OSHA is primarily concerned with what?', ['Workplace safety and health', 'Company marketing', 'Payroll', 'Product pricing'], 0),
    Question('Which is a core OSHA activity?', ['Setting and enforcing standards', 'Selling PPE', 'Issuing driving licenses', 'Approving salaries'], 0),
  ]),
  Lesson('osha-2', 'OSHA and the CFR', 'How OSHA standards fit into federal regulations',
      '''The Code of Federal Regulations (CFR) is organized by titles. OSHA requirements are primarily found in Title 29, Labor. General Industry requirements are commonly located in 29 CFR Part 1910, while Construction requirements are commonly located in 29 CFR Part 1926.''', [
    Question('Which CFR title contains OSHA regulations?', ['Title 29', 'Title 10', 'Title 40', 'Title 49'], 0),
    Question('Where are General Industry standards primarily found?', ['29 CFR 1910', '29 CFR 1926', '29 CFR 3000', '40 CFR 1910'], 0),
  ]),
  Lesson('osha-3', 'General Industry / 1910', 'Core General Industry standards',
      '''29 CFR 1910 covers General Industry. In practice, an HSE professional should learn how to locate applicable requirements, understand scope and definitions, identify mandatory controls, and translate requirements into workplace procedures, inspections and training.''', [
    Question('29 CFR 1910 is mainly associated with:', ['General Industry', 'Construction only', 'Environmental permits', 'Tax rules'], 0),
    Question('What should an HSE professional do with a standard?', ['Translate requirements into effective controls', 'Ignore definitions', 'Use it only after an accident', 'Replace all site procedures automatically'], 0),
  ]),
  Lesson('osha-4', 'Construction / 1926', 'Construction standards and field application',
      '''29 CFR 1926 contains OSHA Construction standards. Construction work often involves changing work fronts, temporary conditions, lifting, excavation, electrical hazards, work at height and simultaneous activities. The HSE professional must evaluate the actual task and applicable requirements.''', [
    Question('29 CFR 1926 is primarily for:', ['Construction', 'General Industry', 'Food labeling', 'Road taxation'], 0),
    Question('Why is field verification important in construction?', ['Conditions can change quickly', 'Standards do not matter', 'Only paperwork matters', 'Hazards are always static'], 0),
  ]),
  Lesson('osha-5', 'Responsibilities and Field Inspection', 'Employer/employee duties and inspection logic',
      '''A useful inspection starts with understanding the task, identifying hazards, checking existing controls, interviewing workers, reviewing records where relevant, and documenting corrective actions. Good inspection practice connects observations to risk and practical corrective measures.''', [
    Question('A strong field inspection should begin with:', ['Understanding the task and hazards', 'Writing a penalty immediately', 'Ignoring workers', 'Checking only housekeeping'], 0),
    Question('A corrective action should be:', ['Specific and trackable', 'Vague', 'Verbal only', 'Never assigned to an owner'], 0),
  ]),
  Lesson('osha-6', 'Hazardous Energy and LOTO', 'Lockout/Tagout fundamentals and field practice',
      '''LOTO is used to prevent unexpected energization, start-up or release of stored energy during servicing and maintenance. A robust process includes shutdown, isolation, lockout/tagout, release or restraint of stored energy, verification of isolation, and controlled restoration.''', [
    Question('The purpose of LOTO is to control:', ['Hazardous energy', 'Office attendance', 'Training budgets', 'Production targets'], 0),
    Question('Before work starts, isolation should be:', ['Verified', 'Assumed', 'Left to memory', 'Checked only after the job'], 0),
  ]),
];

final List<Course> courses = [
  Course('osha', 'OSHA Fundamentals', 'OSHA, CFR, inspections and LOTO', Icons.shield, oshaLessons),
  Course('hsepro', 'HSE Pro: From Field to Insight', '90-Day Professional HSE Development Program', Icons.engineering,
      List.generate(12, (i) => Lesson('hse-${i + 1}', 'Week ${i + 1}', hseWeeks[i],
          'Professional HSE development lesson with field practice, reflection and a practical assignment.', [
        Question('What is the main purpose of this week?', ['Build practical HSE capability', 'Skip field verification', 'Avoid documentation', 'Remove all inspections'], 0),
      ]))),
  Course('iso', 'ISO 45001', 'Occupational Health & Safety Management Systems', Icons.verified_user, genericLessons('ISO 45001', 6)),
  Course('risk', 'Risk Assessment & HIRA', 'Identify, assess and control risks effectively', Icons.warning_amber, genericLessons('Risk Assessment', 6)),
  Course('rca', 'Incident Investigation & RCA', 'Find root causes and prevent recurrence', Icons.search, genericLessons('Incident Investigation', 6)),
  Course('loto', 'LOTO & Hazardous Energy', 'Isolation, lockout and verification', Icons.lock, genericLessons('LOTO', 6)),
  Course('data', 'HSE Data Analysis', 'Excel, dashboards and HSE indicators', Icons.analytics, genericLessons('HSE Data Analysis', 6)),
  Course('inspection', 'Practical HSE Inspection', 'Field inspection and action tracking', Icons.fact_check, genericLessons('HSE Inspection', 6)),
];

const hseWeeks = [
  'Cognitive biases and HSE mindset',
  'OSHA, NEBOSH, ISO 45001 and HSE indicators',
  'Hazard identification, JSA and inspection',
  '5 Whys and 5 Layers practical exercise',
  'Advanced Excel: Pivot, trends and dashboards',
  'HSE software and data interpretation',
  'ISO 45001 clauses 4–6 and gap analysis',
  'First analytical report and professional portfolio',
  'Operator networking and field information',
  'Second analytical report',
  'Power Query, pattern discovery and third report',
  'Final portfolio and professional presentation',
];

List<Lesson> genericLessons(String name, int count) => List.generate(count, (i) => Lesson(
      '$name-$i',
      'Module ${i + 1}: $name',
      'Lesson ${i + 1} and practical field exercise',
      'This module introduces the core principles of $name, explains the practical workflow, and ends with a field-oriented exercise. The full curriculum will be expanded with detailed English source text, Persian instruction, examples and assessments.',
      [Question('What is the best approach in HSE practice?', ['Identify the hazard and apply effective controls', 'Ignore the task', 'Only complete paperwork', 'Wait for an incident'], 0)],
    ));

Course courseById(String id) => courses.firstWhere((c) => c.id == id);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  Future<void> enter() async {
    final u = email.text.trim().toLowerCase();
    if (u.isEmpty || password.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter an email and a password with at least 4 characters.')));
      return;
    }
    setState(() => busy = true);
    final sp = await SharedPreferences.getInstance();
    await sp.setString('active_user', u);
    await sp.setString('user_${u}_name', sp.getString('user_${u}_name') ?? u.split('@').first);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeShell(user: u)));
  }
  @override Widget build(BuildContext c) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
      const Icon(Icons.engineering, size: 76, color: Colors.green),
      const SizedBox(height: 8),
      const Text('HSE Academy', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      const Text('Professional HSE Learning & Practice Platform', textAlign: TextAlign.center),
      const SizedBox(height: 28),
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: busy ? null : enter, icon: const Icon(Icons.login), label: Text(busy ? 'Opening...' : 'Create account / Sign in'))),
      const SizedBox(height: 24),
      const Text('Your learning progress is stored separately for this account on the device.'),
      const SizedBox(height: 18),
      const Text('Founded & Developed by Mahdi Shahmoradi'),
    ]))),
  );
}

class HomeShell extends StatefulWidget {
  final String user;
  const HomeShell({super.key, required this.user});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index = 0;
  @override Widget build(BuildContext c) => Scaffold(
    body: IndexedStack(index: index, children: [
      HomePage(user: widget.user, onCourses: () => setState(() => index = 1)),
      CoursesPage(user: widget.user),
      const ToolsPage(),
      ProfilePage(user: widget.user),
    ]),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (x) => setState(() => index = x), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Courses'),
      NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Tools'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ]),
  );
}

class HomePage extends StatefulWidget {
  final String user; final VoidCallback onCourses;
  const HomePage({super.key, required this.user, required this.onCourses});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  Map<String, double> progress = {};
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final map = <String, double>{};
    for (final c in courses) {
      final raw = sp.getString('user_${widget.user}_${c.id}_done') ?? '[]';
      final done = (jsonDecode(raw) as List).length;
      map[c.id] = c.lessons.isEmpty ? 0 : done / c.lessons.length;
    }
    if (mounted) setState(() => progress = map);
  }
  @override Widget build(BuildContext c) {
    final o = progress['osha'] ?? 0;
    return SafeArea(child: RefreshIndicator(onRefresh: load, child: ListView(padding: const EdgeInsets.all(18), children: [
      Text('HSE Academy', style: Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      Text('Hello, ${widget.user.split('@').first}', style: Theme.of(c).textTheme.titleMedium),
      const SizedBox(height: 18),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Continue OSHA Fundamentals', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6), Text('${(o * 100).round()}% completed'),
        const SizedBox(height: 10), LinearProgressIndicator(value: o),
        const SizedBox(height: 14), FilledButton(onPressed: widget.onCourses, child: const Text('Continue Learning')),
      ]))),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('My Courses', style: Theme.of(c).textTheme.titleLarge), TextButton(onPressed: widget.onCourses, child: const Text('View all'))]),
      ...courses.take(5).map((x) => Card(child: ListTile(leading: CircleAvatar(child: Icon(x.icon)), title: Text(x.title), subtitle: LinearProgressIndicator(value: progress[x.id] ?? 0), onTap: widget.onCourses))),
    ])));
  }
}

class CoursesPage extends StatelessWidget {
  final String user;
  const CoursesPage({super.key, required this.user});
  @override Widget build(BuildContext c) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    Text('Courses', style: Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
    const SizedBox(height: 10),
    ...courses.map((x) => Card(child: ListTile(leading: CircleAvatar(child: Icon(x.icon)), title: Text(x.title), subtitle: Text(x.subtitle), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => CoursePage(user: user, course: x))))),
  ]));
}

class CoursePage extends StatefulWidget {
  final String user; final Course course;
  const CoursePage({super.key, required this.user, required this.course});
  @override State<CoursePage> createState() => _CoursePageState();
}
class _CoursePageState extends State<CoursePage> {
  Set<String> done = {};
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('user_${widget.user}_${widget.course.id}_done') ?? '[]';
    if (mounted) setState(() => done = (jsonDecode(raw) as List).cast<String>().toSet());
  }
  Future<void> markDone(String id) async {
    final p = await SharedPreferences.getInstance();
    setState(() => done.add(id));
    await p.setString('user_${widget.user}_${widget.course.id}_done', jsonEncode(done.toList()));
  }
  @override Widget build(BuildContext c) {
    final total = widget.course.lessons.length;
    final pct = total == 0 ? 0.0 : done.length / total;
    return Scaffold(appBar: AppBar(title: Text(widget.course.title)), body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.course.subtitle, style: Theme.of(c).textTheme.titleMedium),
        const SizedBox(height: 12), LinearProgressIndicator(value: pct),
        const SizedBox(height: 8), Text('${done.length} of $total lessons completed'),
      ]))),
      const SizedBox(height: 8),
      ...widget.course.lessons.asMap().entries.map((entry) {
        final lesson = entry.value; final completed = done.contains(lesson.id);
        return Card(child: ListTile(
          leading: CircleAvatar(child: Text('${entry.key + 1}')),
          title: Text(lesson.title), subtitle: Text(lesson.summary),
          trailing: Icon(completed ? Icons.check_circle : Icons.chevron_right, color: completed ? Colors.green : null),
          onTap: () async {
            await Navigator.push(c, MaterialPageRoute(builder: (_) => LessonPage(user: widget.user, course: widget.course, lesson: lesson)));
            await load();
          },
        ));
      }),
    ]));
  }
}

class LessonPage extends StatefulWidget {
  final String user; final Course course; final Lesson lesson;
  const LessonPage({super.key, required this.user, required this.course, required this.lesson});
  @override State<LessonPage> createState() => _LessonPageState();
}
class _LessonPageState extends State<LessonPage> {
  int question = 0; int selected = -1; int score = 0; bool answered = false; bool finished = false;
  Future<void> complete() async {
    final p = await SharedPreferences.getInstance();
    final key = 'user_${widget.user}_${widget.course.id}_done';
    final raw = p.getString(key) ?? '[]';
    final done = (jsonDecode(raw) as List).cast<String>().toSet()..add(widget.lesson.id);
    await p.setString(key, jsonEncode(done.toList()));
  }
  void answer(int index) {
    if (answered || finished) return;
    setState(() { selected = index; answered = true; if (index == widget.lesson.questions[question].answer) score++; });
  }
  Future<void> next() async {
    if (question + 1 < widget.lesson.questions.length) {
      setState(() { question++; selected = -1; answered = false; });
    } else {
      await complete();
      setState(() => finished = true);
    }
  }
  @override Widget build(BuildContext c) {
    if (finished) return Scaffold(appBar: AppBar(title: const Text('Lesson Result')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.emoji_events, size: 70, color: Colors.green),
      const SizedBox(height: 12), Text('Lesson completed!', style: Theme.of(c).textTheme.headlineSmall),
      const SizedBox(height: 8), Text('Score: $score / ${widget.lesson.questions.length}'),
      const SizedBox(height: 20), FilledButton(onPressed: () => Navigator.pop(c), child: const Text('Back to course')),
    ]))));
    final q = widget.lesson.questions[question];
    return Scaffold(appBar: AppBar(title: Text(widget.lesson.title)), body: ListView(padding: const EdgeInsets.all(18), children: [
      Text(widget.lesson.summary, style: Theme.of(c).textTheme.titleMedium),
      const SizedBox(height: 16),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(widget.lesson.body, style: const TextStyle(fontSize: 16, height: 1.5)))),
      const SizedBox(height: 18),
      Text('Knowledge Check ${question + 1}/${widget.lesson.questions.length}', style: Theme.of(c).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10), Text(q.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      ...q.options.asMap().entries.map((e) {
        final isCorrect = e.key == q.answer; final isSelected = e.key == selected;
        Color? color;
        if (answered && isCorrect) color = Colors.green.shade100;
        if (answered && isSelected && !isCorrect) color = Colors.red.shade100;
        return Card(color: color, child: ListTile(leading: CircleAvatar(child: Text(String.fromCharCode(65 + e.key))), title: Text(e.value), onTap: () => answer(e.key)));
      }),
      const SizedBox(height: 12),
      if (answered) FilledButton(onPressed: next, child: Text(question + 1 == widget.lesson.questions.length ? 'Finish Lesson' : 'Next Question')),
    ]));
  }
}

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});
  @override Widget build(BuildContext c) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    Text('HSE Tools', style: Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    ...['JSA Builder', 'Checklists', 'Risk Assessment', 'Incident Report', 'LOTO Guide', 'Hazardous Materials', 'Daily Inspection', 'Templates'].map((x) => Card(child: ListTile(leading: const Icon(Icons.build), title: Text(x), trailing: const Icon(Icons.chevron_right), onTap: () => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('$x will be added in the next modules.')))))),
  ]));
}

class ProfilePage extends StatefulWidget {
  final String user; const ProfilePage({super.key, required this.user});
  @override State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final name = TextEditingController(), job = TextEditingController(), position = TextEditingController(), company = TextEditingController();
  String? photoPath;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    name.text = p.getString('user_${widget.user}_name') ?? widget.user.split('@').first;
    job.text = p.getString('user_${widget.user}_job') ?? '';
    position.text = p.getString('user_${widget.user}_position') ?? '';
    company.text = p.getString('user_${widget.user}_company') ?? '';
    photoPath = p.getString('user_${widget.user}_photo');
    if (mounted) setState(() {});
  }
  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('user_${widget.user}_name', name.text);
    await p.setString('user_${widget.user}_job', job.text);
    await p.setString('user_${widget.user}_position', position.text);
    await p.setString('user_${widget.user}_company', company.text);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved.')));
  }
  Future<void> choosePhoto() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final p = await SharedPreferences.getInstance();
    await p.setString('user_${widget.user}_photo', x.path);
    setState(() => photoPath = x.path);
  }
  @override Widget build(BuildContext c) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    Center(child: CircleAvatar(radius: 46, backgroundImage: photoPath != null ? FileImage(File(photoPath!)) : null, child: photoPath == null ? const Icon(Icons.person, size: 46) : null)),
    const SizedBox(height: 10),
    Center(child: Text(widget.user, style: Theme.of(c).textTheme.bodySmall)),
    const SizedBox(height: 14),
    ...[('Full name', name), ('Job', job), ('Position', position), ('Company / Organization', company)].map((x) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextField(controller: x.$2, decoration: InputDecoration(labelText: x.$1, border: const OutlineInputBorder())))),
    FilledButton(onPressed: save, child: const Text('Save profile')),
    OutlinedButton.icon(onPressed: choosePhoto, icon: const Icon(Icons.photo), label: const Text('Choose profile photo')),
    const SizedBox(height: 20),
    const Text('HSE Academy • Founded & Developed by Mahdi Shahmoradi', textAlign: TextAlign.center),
  ]));
}
