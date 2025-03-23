import 'package:flutter/material.dart';
import 'package:manajemen_state/provider/plan_provider.dart';
import '../models/data_layer_models.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController()..addListener(() {
          FocusScope.of(context).unfocus();
        });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          if (plans.isEmpty) {
            return const Center(
              child: Text('Belum ada rencana yang tersedia.'),
            );
          }
          Plan? currentPlan = plans.firstWhere(
            (p) => p.name == plan.name,
            orElse: () => Plan(name: plan.name, tasks: []),
          );
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        List<Plan> plans = planNotifier.value;
        int planIndex = plans.indexWhere((p) => p.name == plan.name);

        if (planIndex == -1) {
          plans.add(Plan(name: plan.name, tasks: [const Task()]));
        } else {
          plans[planIndex].tasks.add(const Task());
        }

        planNotifier.value = List<Plan>.from(plans);
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) => _buildTaskTile(plan, index, context),
    );
  }

  Widget _buildTaskTile(Plan plan, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    Task task = plan.tasks[index];

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          int planIndex = planNotifier.value.indexWhere(
            (p) => p.name == plan.name,
          );
          if (planIndex != -1) {
            planNotifier.value[planIndex].tasks[index] = Task(
              description: task.description,
              complete: selected ?? false,
            );
            planNotifier.notifyListeners();
          }
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          int planIndex = planNotifier.value.indexWhere(
            (p) => p.name == plan.name,
          );
          if (planIndex != -1) {
            planNotifier.value[planIndex].tasks[index] = Task(
              description: text,
              complete: task.complete,
            );
            planNotifier.notifyListeners();
          }
        },
      ),
    );
  }
}
