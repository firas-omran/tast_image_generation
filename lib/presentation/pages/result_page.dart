import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/generator_bloc.dart';
import '../bloc/generator_event.dart';
import '../bloc/generator_state.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeneratorBloc>().add(const GenerateRequested(fresh: true));
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CircularProgressIndicator(
                strokeWidth: 4.w,
                valueColor: AlwaysStoppedAnimation(
                  Color.lerp(Colors.indigo, Colors.purple, _animController.value),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Text('Generating...', style: TextStyle(fontSize: 16.sp)),
      ],
    );
  }


  Widget _buildImage(String assetPath) {
    _animController.reset();
    _animController.forward();

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_fadeAnim),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(_fadeAnim),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300.h,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: BlocConsumer<GeneratorBloc, GeneratorState>(
          listenWhen: (prev, curr) => curr.status == GeneratorStatus.failure && curr.errorMessage != null,
          listener: (context, state) {
            if (state.status == GeneratorStatus.failure) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Unknown error')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: () {
                      if (state.status == GeneratorStatus.loading) {
                        return _buildLoader();
                      } else if (state.status == GeneratorStatus.success && state.imagePath != null) {
                        return _buildImage(state.imagePath!);
                      } else if (state.status == GeneratorStatus.failure) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 64.r, color: Colors.redAccent),
                            SizedBox(height: 12.h),
                            Text('Generation failed', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8.h),
                            Text(state.errorMessage ?? 'Unknown error', textAlign: TextAlign.center),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<GeneratorBloc>().add(RetryRequested());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            )
                          ],
                        );
                      } else {

                        return const Text('No result yet');
                      }
                    }(),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          context.read<GeneratorBloc>().add(const GenerateRequested(fresh: true));
                        },
                        child: const Text('Try another'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('New prompt'),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
