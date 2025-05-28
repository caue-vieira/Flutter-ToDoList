import 'package:app_task/models/task.dart';
import 'package:app_task/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTaskWidget extends StatefulWidget {
  final Task task;

  const EditTaskWidget({super.key, required this.task});

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        isCompleted: _selectedStatus == TaskStatus.Concluido,
      );

      Provider.of<TaskProvider>(context, listen: false).editTask(updatedTask);
      Navigator.pop(context);
    }
  }

  void _deleteTask() {
    Provider.of<TaskProvider>(context, listen: false).deleteTask(widget.task.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Editar Tarefa', style: theme.textTheme.headlineMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                onPressed: _updateTask,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Salvar', style: theme.textTheme.titleSmall),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira um título.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                      decoration: const InputDecoration(
                        labelText: 'Descrição...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      minLines: 3,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Status da Tarefa:',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2D2D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskStatus>(
                          value: _selectedStatus,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2F2D2D),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: theme.textTheme.bodyMedium,
                          items: TaskStatus.values.map((TaskStatus status) {
                            return DropdownMenuItem<TaskStatus>(
                              value: status,
                              child: Text(status.statusText),
                            );
                          }).toList(),
                          onChanged: (TaskStatus? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _deleteTask,
          backgroundColor: const Color(0xFF202020),
          child: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}
