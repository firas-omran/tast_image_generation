import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/generator_bloc.dart';
import '../bloc/generator_event.dart';
import '../bloc/generator_state.dart';
import 'result_page.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({Key? key}) : super(key: key);

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    final prompt = context.read<GeneratorBloc>().state.prompt;
    _controller = TextEditingController(text: prompt);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGenerateTap(String prompt) {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must write something')),
      );
      return;
    }


    context.read<GeneratorBloc>().add(PromptChanged(prompt));

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            TextField(
              controller: _controller,
              onChanged: (v) => context.read<GeneratorBloc>().add(PromptChanged(v)),
              decoration: InputDecoration(
                hintText: 'Describe what you want to see…',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
              minLines: 3,
              maxLines: 6,
            ),
            SizedBox(height: 20.h),
            BlocBuilder<GeneratorBloc, GeneratorState>(
              builder: (context, state) {
                final isEmpty = state.prompt.trim().isEmpty;
                return GestureDetector(
                  onTap: () {
                    if (isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must write something')),
                      );
                    } else {
                      _onGenerateTap(state.prompt);
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: false,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isEmpty ? 0.6 : 1.0,
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Generate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
